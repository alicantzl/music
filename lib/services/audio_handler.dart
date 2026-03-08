import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';

class PureAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();

  List<SongModel> _queue = [];
  int _currentIndex = 0;
  bool _shuffleMode = false;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;

  PureAudioHandler() {
    _initSession();
    _player.playbackEventStream.listen(
      (_) => _broadcastState(),
      onError: (e) => debugPrint('Playback event error: $e'),
    );
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) _onComplete();
    });
  }

  Future<void> _initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> _onComplete() async {
    switch (_repeatMode) {
      case AudioServiceRepeatMode.one:
        await _player.seek(Duration.zero);
        await _player.play();
        break;
      case AudioServiceRepeatMode.all:
        await skipToNext();
        break;
      default:
        if (_currentIndex < _queue.length - 1) {
          await skipToNext();
        } else {
          await stop();
        }
    }
  }

  Future<void> playSong(SongModel song, {List<SongModel>? queue}) async {
    if (queue != null && queue.isNotEmpty) {
      _queue = List.from(queue);
      _currentIndex = _queue.indexWhere((s) => s.id == song.id);
      if (_currentIndex < 0) {
        _queue.insert(0, song);
        _currentIndex = 0;
      }
    } else {
      _queue = [song];
      _currentIndex = 0;
    }
    await _load(song);
  }

  Future<void> _load(SongModel song) async {
    await _player.stop();

    mediaItem.add(_songToItem(song));
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
    ));

    try {
      // First check: song model says it's downloaded
      if (song.isDownloaded && song.localPath != null) {
        final file = File(song.localPath!);
        if (await file.exists()) {
          debugPrint('Playing from model local path');
          await _player.setFilePath(song.localPath!);
          await _player.play();
          return;
        }
      }

      // Second check: Hive downloads box (user pressed download button before)
      final downloadsBox = Hive.box('downloads');
      if (downloadsBox.containsKey(song.id)) {
        final data = Map<String, dynamic>.from(downloadsBox.get(song.id) as Map);
        final localPath = data['localPath'] as String?;
        if (localPath != null) {
          final file = File(localPath);
          if (await file.exists()) {
            debugPrint('Playing from permanent download: $localPath');
            await _player.setFilePath(localPath);
            await _player.play();
            return;
          }
        }
      }

      // Get YouTube stream - ONLY MP4/M4A format (iOS compatible)
      final manifest = await _yt.videos.streamsClient.getManifest(song.id);

      // iOS ONLY supports MP4/AAC. WebM/Opus will NOT work.
      // Priority: audio-only MP4 > muxed MP4
      final mp4AudioOnly = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      Uri streamUri;
      if (mp4AudioOnly.isNotEmpty) {
        // Sort by bitrate, pick highest
        mp4AudioOnly.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        streamUri = mp4AudioOnly.first.url;
        debugPrint('Using MP4 audio-only: ${mp4AudioOnly.first.bitrate}bps');
      } else if (manifest.muxed.isNotEmpty) {
        // Fallback: muxed MP4 (has video too but works)
        final muxed = manifest.muxed
            .where((s) => s.container.name.toLowerCase() == 'mp4')
            .toList();
        if (muxed.isNotEmpty) {
          muxed.sort((a, b) => b.bitrate.compareTo(a.bitrate));
          streamUri = muxed.first.url;
          debugPrint('Using muxed MP4: ${muxed.first.bitrate}bps');
        } else {
          streamUri = manifest.muxed.first.url;
          debugPrint('Using muxed fallback');
        }
      } else {
        throw Exception('No MP4 stream available');
      }

      // Play directly from URL
      await _player.setUrl(streamUri.toString());

      // Update duration from actual stream
      final realDuration = _player.duration;
      if (realDuration != null && realDuration.inSeconds > 0) {
        mediaItem.add(_songToItem(song).copyWith(duration: realDuration));
      }

      await _player.play();
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ));
      debugPrint('Audio Error: $e');
    }
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration pos) => _player.seek(pos);

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  @override
  Future<void> skipToNext() async {
    if (_queue.isEmpty) return;
    if (_shuffleMode) {
      final others = List.generate(_queue.length, (i) => i)..remove(_currentIndex);
      if (others.isNotEmpty) {
        others.shuffle();
        _currentIndex = others.first;
      }
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    await _load(_queue[_currentIndex]);
  }

  @override
  Future<void> skipToPrevious() async {
    if (_queue.isEmpty) return;
    if (_player.position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
      return;
    }
    _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    await _load(_queue[_currentIndex]);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode mode) async {
    _shuffleMode = mode == AudioServiceShuffleMode.all;
    playbackState.add(playbackState.value.copyWith(shuffleMode: mode));
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode mode) async {
    _repeatMode = mode;
    playbackState.add(playbackState.value.copyWith(repeatMode: mode));
  }

  void _broadcastState() {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _currentIndex,
    ));
  }

  MediaItem _songToItem(SongModel song) => MediaItem(
        id: song.id,
        title: song.title,
        artist: song.artist,
        album: song.album ?? 'YouTube Music',
        duration: song.duration,
        artUri: Uri.tryParse(song.albumArt),
        extras: {'localPath': song.localPath},
      );

  AudioPlayer get player => _player;
  List<SongModel> get songQueue => List.unmodifiable(_queue);
  int get songIndex => _currentIndex;
  SongModel? get songCurrent => _queue.isNotEmpty ? _queue[_currentIndex] : null;
}

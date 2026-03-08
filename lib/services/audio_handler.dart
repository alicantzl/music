import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
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
    _player.playbackEventStream.listen(
      (_) => _broadcastState(),
      onError: (e) {
        debugPrint('Playback event error: $e');
      },
    );
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) _onComplete();
    });
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

  /// The key method: downloads the YouTube audio stream to a temp file,
  /// then plays from that local file. This bypasses all iOS URL/header issues.
  Future<void> _load(SongModel song) async {
    // Stop current playback
    await _player.stop();
    
    mediaItem.add(_songToItem(song));
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
    ));

    try {
      if (song.isDownloaded && song.localPath != null) {
        // Already downloaded — play from local file
        await _player.setFilePath(song.localPath!);
      } else {
        // Stream from YouTube via temp file approach
        // This is THE fix for iOS: download the stream bytes to a temp file,
        // then play from that file. just_audio handles local files perfectly.
        final tempFile = await _downloadToTemp(song.id);
        await _player.setFilePath(tempFile.path);
      }
      
      // Update duration from player if available
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
      debugPrint('PureMusic Audio Error: $e');
    }
  }

  /// Downloads a YouTube audio stream to a temporary file and returns the File.
  Future<File> _downloadToTemp(String videoId) async {
    final manifest = await _yt.videos.streamsClient.getManifest(videoId);
    
    // Pick the best audio stream
    StreamInfo? streamInfo;
    
    // Strategy 1: MP4 audio-only (best iOS compatibility)
    final mp4Audio = manifest.audioOnly
        .where((s) => s.container.name.toLowerCase() == 'mp4')
        .toList();
    if (mp4Audio.isNotEmpty) {
      mp4Audio.sort((a, b) => b.bitrate.compareTo(a.bitrate));
      // Pick medium quality for faster loading (not the absolute highest)
      streamInfo = mp4Audio.length > 1 ? mp4Audio[1] : mp4Audio.first;
    }
    
    // Strategy 2: Any audio-only stream
    if (streamInfo == null && manifest.audioOnly.isNotEmpty) {
      streamInfo = manifest.audioOnly.withHighestBitrate();
    }
    
    // Strategy 3: Muxed (video+audio) as last resort
    if (streamInfo == null && manifest.muxed.isNotEmpty) {
      streamInfo = manifest.muxed.withHighestBitrate();
    }

    if (streamInfo == null) {
      throw Exception('No playable stream found for $videoId');
    }

    // Get temp directory
    final tempDir = await getTemporaryDirectory();
    final ext = streamInfo.container.name.toLowerCase() == 'mp4' ? 'm4a' : 'webm';
    final tempFile = File('${tempDir.path}/puremusic_$videoId.$ext');
    
    // Only download if not already cached
    if (await tempFile.exists() && await tempFile.length() > 1000) {
      debugPrint('Using cached: ${tempFile.path}');
      return tempFile;
    }

    debugPrint('Downloading stream for $videoId...');
    final stream = _yt.videos.streamsClient.get(streamInfo);
    final sink = tempFile.openWrite();
    await stream.pipe(sink);
    await sink.flush();
    await sink.close();
    debugPrint('Downloaded: ${await tempFile.length()} bytes');

    return tempFile;
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

  Future<void> addToQueue(SongModel song) async => _queue.add(song);
  Future<void> addToQueueNext(SongModel song) async =>
      _queue.insert(_currentIndex + 1, song);

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
        extras: {'localPath': song.localPath, 'isDownloaded': song.isDownloaded},
      );

  AudioPlayer get player => _player;
  List<SongModel> get songQueue => List.unmodifiable(_queue);
  int get songIndex => _currentIndex;
  SongModel? get songCurrent => _queue.isNotEmpty ? _queue[_currentIndex] : null;
}

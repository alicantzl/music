import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/song_model.dart';
import 'stream_resolver.dart';
import 'proxy_audio_source.dart';

class PureAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();


  String? _currentLoadingId;
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
    await session.setActive(true);
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
    _currentLoadingId = song.id;
    final loadingId = song.id;

    debugPrint('*** Starting Load Sequence for: ${song.title} ***');
    await _player.stop();

    mediaItem.add(_songToItem(song));
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
    ));

    try {
      // 1. Check Offline / Downloads
      if (song.isDownloaded && song.localPath != null && await File(song.localPath!).exists()) {
        debugPrint('--- Playing from local path: ${song.localPath} ---');
        if (_currentLoadingId != loadingId) return;
        await _player.setFilePath(song.localPath!);
        await _player.play();
        return;
      }

      final downloadsBox = Hive.box('downloads');
      if (downloadsBox.containsKey(song.id)) {
        final data = Map<String, dynamic>.from(downloadsBox.get(song.id) as Map);
        final localPath = data['localPath'] as String?;
        if (localPath != null && await File(localPath).exists()) {
          debugPrint('--- Playing from permanent download: $localPath ---');
          if (_currentLoadingId != loadingId) return;
          await _player.setFilePath(localPath);
          await _player.play();
          return;
        }
      }

      // 2. Resolve Stream
      debugPrint('--- Resolving stream for ${song.title}... ---');
      ResolvedStream? resolved = await StreamResolver.resolve(
        song.id,
        title: song.title,
        artist: song.artist,
      );

      if (_currentLoadingId != loadingId) {
        debugPrint('Request cancelled for ${song.id} during resolution');
        return;
      }

      if (resolved == null) throw Exception('Stream resolution failed.');

      // 3. Set Audio Source
      bool isSaavn = resolved.url != null && (resolved.url!.contains('saavncdn.com') || resolved.url!.contains('jiosaavn'));
      
      if (isSaavn) {
        debugPrint('--- Loading Saavn Stream: ${resolved.url} ---');
        await _player.setAudioSource(
          AudioSource.uri(
            Uri.parse(resolved.url!),
            headers: {
              'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
            },
          ),
          preload: true,
        );
      } else {
        debugPrint('--- Loading YouTube/Fallback via Proxy ---');
        await _player.setAudioSource(CustomProxyAudioSource(
          id: song.id,
          resolved: resolved,
        ), preload: true);
      }

      if (_currentLoadingId != loadingId) return;

      // Update duration
      final realDuration = _player.duration;
      if (realDuration != null && realDuration.inSeconds > 0) {
        mediaItem.add(_songToItem(song).copyWith(duration: realDuration));
      }

      debugPrint('--- Source READY. Calling play() for ${song.id}... ---');
      await _player.play().timeout(const Duration(seconds: 10), onTimeout: () {
        debugPrint('!!! PLAY TIMEOUT reached for ${song.id} !!!');
      });
      debugPrint('--- Play command executed successfully for ${song.id} ---');

    } catch (e) {
      if (_currentLoadingId == loadingId) {
        debugPrint('CRITICAL Playback Error for ${song.id}: $e');
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          playing: false,
        ));
      }
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

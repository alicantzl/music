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
import 'package:path_provider/path_provider.dart';
import 'youtube_service.dart';
import 'dart:math';

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
          // If shuffle is on, infinite play completely random song!
          if (_shuffleMode) {
            await _playRandomSong();
          } else {
            await stop();
          }
        }
    }
  }

  Future<void> _playRandomSong() async {
    try {
      final yt = YoutubeService();
      // Search a random popular artist or word to guarantee "completely different, not similar"
      final randomQueries = ['latest hit', 'popular song 2024', 'music official', 'top charts usa', 'pop music', 'electronic mix', 'rock classic', 'hip hop top'];
      final query = randomQueries[Random().nextInt(randomQueries.length)];
      final songs = await yt.searchSongs(query);
      if (songs.isNotEmpty) {
        final randSong = songs[Random().nextInt(songs.length)];
        _queue.add(randSong);
        _currentIndex = _queue.length - 1;
        await _load(randSong);
      } else {
        await stop();
      }
    } catch (_) {
      await stop();
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
      if (song.isDownloaded && song.localPath != null) {
        String finalPath = song.localPath!;
        if (!finalPath.contains('/')) {
           final dir = await getApplicationDocumentsDirectory();
           finalPath = '${dir.path}/download/$finalPath';
        } else {
           final fileName = finalPath.split('/').last;
           final dir = await getApplicationDocumentsDirectory();
           finalPath = '${dir.path}/download/$fileName';
        }
        
        if (await File(finalPath).exists()) {
          debugPrint('--- Playing from local path: $finalPath ---');
          if (_currentLoadingId != loadingId) return;
          await _player.setFilePath(finalPath);
          await _player.play();
          return;
        }
      }

      final downloadsBox = Hive.box('downloads');
      if (downloadsBox.containsKey(song.id)) {
        final data = Map<String, dynamic>.from(downloadsBox.get(song.id) as Map);
        String? localPath = data['localPath'] as String?;
        if (localPath != null) {
          if (!localPath.contains('/')) {
             final dir = await getApplicationDocumentsDirectory();
             localPath = '${dir.path}/download/$localPath';
          } else {
             final fileName = localPath.split('/').last;
             final dir = await getApplicationDocumentsDirectory();
             localPath = '${dir.path}/download/$fileName';
          }

          if (await File(localPath).exists()) {
            debugPrint('--- Playing from permanent download: $localPath ---');
            if (_currentLoadingId != loadingId) return;
            await _player.setFilePath(localPath);
            await _player.play();
            return;
          }
        }
      }

      // 2. Resolve Stream
      if (_currentLoadingId != loadingId) return;
      final settingsBox = Hive.box('settings');
      final bool ds = settingsBox.get('dataSaver', defaultValue: false);

      debugPrint('--- Resolving stream for ${song.title}... (DataSaver: $ds) ---');
      ResolvedStream? resolved = await StreamResolver.resolve(
        song.id,
        title: song.title,
        artist: song.artist,
        dataSaver: ds,
      );

      if (_currentLoadingId != loadingId) {
        debugPrint('Request cancelled for ${song.id} during resolution');
        return;
      }

      if (resolved == null) throw Exception('Stream resolution failed.');

      if (resolved.url != null) {
        debugPrint('--- Loading Stream Directly: ${resolved.url} ---');
        final isYouTube = resolved.url!.contains('googlevideo.com') || resolved.url!.contains('youtube.com');
        
        await _player.setAudioSource(
          AudioSource.uri(
            Uri.parse(resolved.url!),
            headers: isYouTube ? {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
              'Referer': 'https://www.youtube.com/',
            } : {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
          ),
          preload: true,
        );
      } else {
        throw Exception('No valid audio URL available');
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
      if (_currentIndex == _queue.length - 1) {
         await _playRandomSong();
         return;
      }
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

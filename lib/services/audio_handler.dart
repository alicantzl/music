import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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
      onError: (e) {},
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

  Future<void> _load(SongModel song) async {
    mediaItem.add(_songToItem(song));
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
    ));

    try {
      if (song.isDownloaded && song.localPath != null) {
        await _player.setAudioSource(AudioSource.file(song.localPath!));
      } else {
        // Fetch raw manifest safely to ensure arbitrary network streaming via just_audio works flawlessly
        final manifest = await _yt.videos.streamsClient.getManifest(song.id);
        
        final audioStreams = manifest.audioOnly
            .where((s) => s.container.name.toLowerCase() == 'mp4')
            .toList();
        
        final streamInfo = audioStreams.isNotEmpty 
            ? audioStreams.reduce((a, b) => a.bitrate.compareTo(b.bitrate) > 0 ? a : b)
            : manifest.audioOnly.withHighestBitrate();

        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(streamInfo.url.toString())),
        );
      }
      await _player.play();
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ));
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

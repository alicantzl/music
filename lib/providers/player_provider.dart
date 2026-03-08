import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../services/audio_handler.dart';
import 'audio_handler_provider.dart';

// Current track playing
final currentSongProvider = StreamProvider<SongModel?>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.mediaItem.map((item) {
    if (item == null) return null;
    return SongModel(
      id: item.id,
      title: item.title,
      artist: item.artist ?? 'Unknown',
      albumArt: item.artUri?.toString() ?? '',
      durationSeconds: item.duration?.inSeconds ?? 0,
      localPath: item.extras?['localPath'],
      album: item.album,
    );
  });
});

// Reactively exposes the current raw playback state (buffering, playing, idle)
final playbackStateProvider = StreamProvider<PlaybackState>((ref) {
  return ref.watch(audioHandlerProvider).playbackState;
});

final isPlayingProvider = Provider<bool>((ref) {
  final state = ref.watch(playbackStateProvider);
  return state.whenData((s) => s.playing).value ?? false;
});

final processingStateProvider = Provider<AudioProcessingState>((ref) {
  final state = ref.watch(playbackStateProvider);
  return state.whenData((s) => s.processingState).value ?? AudioProcessingState.idle;
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(audioHandlerProvider).player.positionStream;
});

// Provides access to shuffle and repeat modes
final shuffleModeProvider = Provider<bool>((ref) {
  final state = ref.watch(playbackStateProvider);
  return state.whenData((s) => s.shuffleMode == AudioServiceShuffleMode.all).value ?? false;
});

final repeatModeProvider = Provider<AudioServiceRepeatMode>((ref) {
  final state = ref.watch(playbackStateProvider);
  return state.whenData((s) => s.repeatMode).value ?? AudioServiceRepeatMode.none;
});

// Queue list
final queueProvider = Provider<List<SongModel>>((ref) {
  return ref.watch(audioHandlerProvider).songQueue;
});

// Notifier class wrapping actions with pure Riverpod logic
class PlayerNotifier extends Notifier<void> {
  @override
  void build() {}

  PureAudioHandler get _handler => ref.read(audioHandlerProvider);

  Future<void> playSong(SongModel song, {List<SongModel>? queue}) async {
    await _handler.playSong(song, queue: queue);
  }

  Future<void> togglePlayPause() async {
    final playing = ref.read(isPlayingProvider);
    playing ? await _handler.pause() : await _handler.play();
  }

  Future<void> seekTo(Duration pos) async => _handler.seek(pos);
  Future<void> skipToNext() async => _handler.skipToNext();
  Future<void> skipToPrevious() async => _handler.skipToPrevious();

  Future<void> toggleShuffle() async {
    final isShuffling = ref.read(shuffleModeProvider);
    await _handler.setShuffleMode(
      isShuffling ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all,
    );
  }

  Future<void> cycleRepeatMode() async {
    final current = ref.read(repeatModeProvider);
    final next = switch (current) {
      AudioServiceRepeatMode.none => AudioServiceRepeatMode.all,
      AudioServiceRepeatMode.all => AudioServiceRepeatMode.one,
      AudioServiceRepeatMode.one => AudioServiceRepeatMode.none,
      _ => AudioServiceRepeatMode.none,
    };
    await _handler.setRepeatMode(next);
  }
}

final playerNotifierProvider = NotifierProvider<PlayerNotifier, void>(PlayerNotifier.new);

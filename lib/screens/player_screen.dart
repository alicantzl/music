import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_service/audio_service.dart';
import '../providers/player_provider.dart';
import '../models/song_model.dart';
import '../services/download_service.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final DownloadService _downloadService = DownloadService();
  bool _isDownloading = false;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleLike(SongModel song) {
    final box = Hive.box('liked_songs');
    if (box.containsKey(song.id)) {
      box.delete(song.id);
    } else {
      box.put(song.id, song.toMap());
    }
    setState(() {});
  }

  Future<void> _download(SongModel song) async {
    setState(() => _isDownloading = true);
    final result = await _downloadService.downloadSong(song);
    if (mounted) {
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result != null ? '✅ Downloaded!' : '❌ Download failed',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: result != null ? const Color(0xFF1DB954) : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(currentSongProvider).value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final processingState = ref.watch(processingStateProvider);
    final isBuffering = processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering;

    if (song == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_off, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text('No song playing', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final isLiked = Hive.box('liked_songs').containsKey(song.id);
    final isDownloaded = Hive.box('downloads').containsKey(song.id) || song.isDownloaded;
    final maxDur = song.duration.inSeconds > 0 ? song.duration.inSeconds.toDouble() : 1.0;
    final curPos = position.inSeconds.toDouble().clamp(0.0, maxDur);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background
          Image.network(song.albumArt, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('PLAYING FROM',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.white60)),
                            Text(song.artist,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Album art with shadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, spreadRadius: 5)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        song.albumArt,
                        width: MediaQuery.of(context).size.width - 80,
                        height: MediaQuery.of(context).size.width - 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: MediaQuery.of(context).size.width - 80,
                          color: Colors.grey[900],
                          child: const Icon(Icons.music_note, size: 80, color: Colors.white38),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Song info + like
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song.title,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(song.artist, style: const TextStyle(fontSize: 16, color: Colors.white60),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? const Color(0xFF1DB954) : Colors.white, size: 28),
                        onPressed: () => _toggleLike(song),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Seek bar
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      min: 0,
                      max: maxDur,
                      value: curPos,
                      onChanged: (v) => ref.read(playerNotifierProvider.notifier).seekTo(Duration(seconds: v.toInt())),
                    ),
                  ),

                  // Time labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fmt(position), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        Text(_fmt(song.duration), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: Colors.white60, size: 22),
                        onPressed: () => ref.read(playerNotifierProvider.notifier).toggleShuffle(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 42, color: Colors.white),
                        onPressed: () => ref.read(playerNotifierProvider.notifier).skipToPrevious(),
                      ),
                      // Play/Pause with loading state
                      GestureDetector(
                        onTap: isBuffering ? null : () => ref.read(playerNotifierProvider.notifier).togglePlayPause(),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: isBuffering
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                                )
                              : Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.black, size: 40),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 42, color: Colors.white),
                        onPressed: () => ref.read(playerNotifierProvider.notifier).skipToNext(),
                      ),
                      _isDownloading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : IconButton(
                              icon: Icon(isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                                  color: isDownloaded ? const Color(0xFF1DB954) : Colors.white60, size: 22),
                              onPressed: isDownloaded ? null : () => _download(song),
                            ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

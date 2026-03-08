import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import '../providers/player_provider.dart';
import '../services/download_service.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final DownloadService _downloadService = DownloadService();
  bool _isDownloading = false;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _toggleLike(String id, Map<String, dynamic> songMap) {
    final box = Hive.box('liked_songs');
    if (box.containsKey(id)) {
      box.delete(id);
    } else {
      box.put(id, songMap);
    }
    setState(() {});
  }

  Future<void> _downloadCurrent(dynamic song) async {
    setState(() => _isDownloading = true);
    await _downloadService.downloadSong(song);
    setState(() => _isDownloading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloaded successfully!', style: TextStyle(color: Colors.white))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(currentSongProvider).value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).value ?? Duration.zero;

    if (song == null) {
      return const Scaffold(body: Center(child: Text('No song playing')));
    }

    final likedBox = Hive.box('liked_songs');
    final isLiked = likedBox.containsKey(song.id);
    
    final downloadedBox = Hive.box('downloads');
    final isDownloaded = downloadedBox.containsKey(song.id) || song.isDownloaded;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[800]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const Text(
                      'NOW PLAYING',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Album Art
              Hero(
                tag: 'albumArt_${song.id}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      song.albumArt,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width - 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Song Info and Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? const Color(0xFF1DB954) : Colors.white,
                        size: 32,
                      ),
                      onPressed: () => _toggleLike(song.id, {
                        'id': song.id,
                        'title': song.title,
                        'artist': song.artist,
                        'albumArt': song.albumArt,
                        'durationSeconds': song.durationSeconds,
                        'localPath': song.localPath,
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    min: 0,
                    max: song.duration.inSeconds.toDouble() > 0 ? song.duration.inSeconds.toDouble() : 100,
                    value: position.inSeconds.toDouble().clamp(0, song.duration.inSeconds.toDouble() > 0 ? song.duration.inSeconds.toDouble() : 100),
                    onChanged: (value) {
                      ref.read(playerNotifierProvider.notifier).seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),

              // Timestamps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(position), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    Text(_formatDuration(song.duration), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ),

              // Playback Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.white),
                      onPressed: () => ref.read(playerNotifierProvider.notifier).toggleShuffle(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                      onPressed: () => ref.read(playerNotifierProvider.notifier).skipToPrevious(),
                    ),
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1DB954)),
                      child: IconButton(
                        iconSize: 48,
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                        onPressed: () => ref.read(playerNotifierProvider.notifier).togglePlayPause(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                      onPressed: () => ref.read(playerNotifierProvider.notifier).skipToNext(),
                    ),
                    _isDownloading 
                        ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFF1DB954), strokeWidth: 2)))
                        : IconButton(
                            icon: Icon(isDownloaded ? Icons.download_done : Icons.download, color: isDownloaded ? const Color(0xFF1DB954) : Colors.white),
                            onPressed: isDownloaded ? null : () => _downloadCurrent(song),
                          ),
                  ],
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

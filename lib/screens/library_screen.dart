import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF1DB954),
                    child: Text('A', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  const Text('Your Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              const TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorColor: Color(0xFF1DB954),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: 'Liked Songs'),
                  Tab(text: 'Downloads'),
                ],
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LikedSongsList(),
            _DownloadsList(),
          ],
        ),
      ),
    );
  }
}

class _LikedSongsList extends ConsumerWidget {
  const _LikedSongsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('liked_songs').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return _buildEmptyState('No liked songs yet.');
        }

        final songs = box.values.map((e) => SongModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 150),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _SongTile(song: song, queue: songs, isLiked: true);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

class _DownloadsList extends ConsumerWidget {
  const _DownloadsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('downloads').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_for_offline_outlined, size: 64, color: Colors.grey[700]),
                const SizedBox(height: 16),
                const Text('No downloads yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        final songs = box.values.map((e) => SongModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 150),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _SongTile(song: song, queue: songs, isDownloaded: true);
          },
        );
      },
    );
  }
}

class _SongTile extends ConsumerWidget {
  final SongModel song;
  final List<SongModel> queue;
  final bool isLiked;
  final bool isDownloaded;

  const _SongTile({required this.song, required this.queue, this.isLiked = false, this.isDownloaded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(song.albumArt, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1),
      trailing: Icon(
        isLiked ? Icons.favorite : (isDownloaded ? Icons.download_done : Icons.more_vert),
        color: (isLiked || isDownloaded) ? const Color(0xFF1DB954) : Colors.grey,
        size: 20,
      ),
      onTap: () {
        ref.read(playerNotifierProvider.notifier).playSong(song, queue: queue);
      },
    );
  }
}

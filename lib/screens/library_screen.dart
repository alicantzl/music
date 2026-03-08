import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box('liked_songs').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No liked songs yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final songs = box.values.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return SongModel(
              id: map['id'],
              title: map['title'],
              artist: map['artist'],
              albumArt: map['albumArt'],
              durationSeconds: map['durationSeconds'],
              localPath: map['localPath'],
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(song.albumArt, width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(song.artist, maxLines: 1),
                trailing: const Icon(Icons.favorite, color: Color(0xFF1DB954)),
                onTap: () {
                  ref.read(playerNotifierProvider.notifier).playSong(song, queue: songs);
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final SongModel song;
  const AddToPlaylistSheet({super.key, required this.song});

  static void show(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => AddToPlaylistSheet(song: song),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        const Text('Add to Playlist', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.white24, height: 30),
        
        ListTile(
          leading: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFF1DB954), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.favorite, color: Colors.white),
          ),
          title: const Text('Liked Songs', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            final box = Hive.box('liked_songs');
            if (!box.containsKey(song.id)) {
              box.put(song.id, song.toMap());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Liked Songs')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already in Liked Songs')));
            }
            Navigator.pop(context);
          },
        ),

        FutureBuilder(
          future: Future.value(Hive.box('playlists')),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final box = snapshot.data as Box;
            return ValueListenableBuilder<Box>(
              valueListenable: box.listenable(),
              builder: (context, playlistBox, _) {
                final playlists = playlistBox.values.cast<PlaylistModel>().toList();
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return ListTile(
                        leading: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.queue_music, color: Colors.white),
                        ),
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.songs.length} songs', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                        onTap: () {
                          final exists = playlist.songs.any((s) => s.id == song.id);
                          if (exists) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already in ${playlist.name}')));
                          } else {
                            final updatedList = List<SongModel>.from(playlist.songs)..add(song);
                            final updatedPlaylist = playlist.copyWith(songs: updatedList);
                            playlistBox.put(playlist.id, updatedPlaylist);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${playlist.name}')));
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

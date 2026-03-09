import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../providers/player_provider.dart';
import '../widgets/song_options_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlist.name, style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              background: Container(
                color: Colors.grey[900],
                child: Center(
                  child: Icon(Icons.library_music, size: 80, color: Colors.grey[800]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('playlists').listenable(),
              builder: (context, box, _) {
                final currentPlaylist = box.get(playlist.id) as PlaylistModel?;
                if (currentPlaylist == null) return const SizedBox();

                final songs = currentPlaylist.songs;
                
                if (songs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.music_off, size: 64, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text('Playlist is empty.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: song.albumArt, width: 50, height: 50, fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(width: 50, height: 50, color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white38)),
                        ),
                      ),
                      title: Text(song.title, maxLines: 1),
                      subtitle: Text(song.artist, maxLines: 1),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Quick Remove option alongside generic options via regular sheet
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF282828),
                            builder: (ctx) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  title: const Text('Remove from this Playlist', style: TextStyle(color: Colors.redAccent)),
                                  onTap: () {
                                     final updatedSongs = List<SongModel>.from(currentPlaylist.songs)..removeWhere((s) => s.id == song.id);
                                     final updatedPlaylist = currentPlaylist.copyWith(songs: updatedSongs);
                                     box.put(playlist.id, updatedPlaylist);
                                     Navigator.pop(ctx);
                                  },
                                ),
                                const Divider(color: Colors.white24, height: 1),
                                ListTile(
                                  leading: const Icon(Icons.more_horiz),
                                  title: const Text('More Options'),
                                  onTap: () {
                                     Navigator.pop(ctx);
                                     SongOptionsSheet.show(context, song);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        ref.read(playerNotifierProvider.notifier).playSong(song, queue: songs);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

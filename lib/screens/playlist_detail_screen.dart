import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../providers/player_provider.dart';
import '../widgets/song_options_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  ConsumerState<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  Future<void> _editPlaylist(BuildContext context, PlaylistModel currentPlaylist) async {
    final TextEditingController nameController = TextEditingController(text: currentPlaylist.name);
    String? newImagePath = currentPlaylist.imagePath;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Edit Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setStateDialog(() {
                      newImagePath = pickedFile.path;
                    });
                  }
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    image: newImagePath != null
                        ? DecorationImage(image: FileImage(File(newImagePath!)), fit: BoxFit.cover)
                        : null,
                  ),
                  child: newImagePath == null
                      ? const Icon(Icons.add_a_photo, color: Colors.white54, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Playlist Name',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1DB954))),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final updatedPlaylist = currentPlaylist.copyWith(
                    name: nameController.text.trim(),
                    imagePath: newImagePath,
                  );
                  Hive.box('playlists').put(currentPlaylist.id, updatedPlaylist);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('playlists').listenable(),
      builder: (context, box, _) {
        final currentPlaylist = box.get(widget.playlist.id) as PlaylistModel?;
        if (currentPlaylist == null) {
          return const Scaffold(body: Center(child: Text("Playlist not found")));
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editPlaylist(context, currentPlaylist),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(currentPlaylist.name, style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                  background: currentPlaylist.imagePath != null
                      ? Image.file(
                          File(currentPlaylist.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: Icon(Icons.library_music, size: 80, color: Colors.grey[800]),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: () {
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
                }(),
              ),
            ],
          ),
        );
      },
  }
}

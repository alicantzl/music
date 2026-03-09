import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';
import 'playlist_detail_screen.dart';
import '../widgets/song_options_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void _createPlaylistDialog() {
    final TextEditingController pc = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('New Playlist'),
        content: TextField(
          controller: pc,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1DB954))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
            onPressed: () {
              if (pc.text.trim().isNotEmpty) {
                final box = Hive.box('playlists');
                final String pId = DateTime.now().millisecondsSinceEpoch.toString();
                final newPlaylist = PlaylistModel(
                  id: pId,
                  name: pc.text.trim(),
                  songs: [],
                  createdAt: DateTime.now(),
                );
                box.put(pId, newPlaylist);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                  if (!_isSearching) ...[
                    const Text('Your Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = true;
                          });
                        }),
                    IconButton(icon: const Icon(Icons.add), onPressed: _createPlaylistDialog),
                  ] else ...[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim().toLowerCase();
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1DB954),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white70,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: 'Playlists'),
                    Tab(text: 'Liked'),
                    Tab(text: 'Downloads'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PlaylistsList(searchQuery: _searchQuery),
            _LikedSongsList(searchQuery: _searchQuery),
            _DownloadsList(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}

class _PlaylistsList extends StatelessWidget {
  final String searchQuery;
  const _PlaylistsList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('playlists').listenable(),
      builder: (context, box, _) {
        var playlists = box.values.cast<PlaylistModel>().toList();

        if (searchQuery.isNotEmpty) {
          playlists = playlists.where((p) => p.name.toLowerCase().contains(searchQuery)).toList();
        }

        if (playlists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue_music, size: 64, color: Colors.grey[700]),
                const SizedBox(height: 16),
                const Text('No playlists found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 150),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                  image: playlist.imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(playlist.imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: playlist.imagePath == null
                    ? const Icon(Icons.music_note, color: Colors.white)
                    : null,
              ),
              title: Text(playlist.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${playlist.songs.length} songs', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistDetailScreen(playlist: playlist),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                   Hive.box('playlists').delete(playlist.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _LikedSongsList extends ConsumerWidget {
  final String searchQuery;
  const _LikedSongsList({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('liked_songs').listenable(),
      builder: (context, box, _) {
        var songs = box.values.map((e) => SongModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();

        if (searchQuery.isNotEmpty) {
          songs = songs.where((s) => s.title.toLowerCase().contains(searchQuery) || s.artist.toLowerCase().contains(searchQuery)).toList();
        }

        if (songs.isEmpty) {
          return _buildEmptyState('No liked songs found.');
        }

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
  final String searchQuery;
  const _DownloadsList({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('downloads').listenable(),
      builder: (context, box, _) {
        var songs = box.values.map((e) => SongModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();

        if (searchQuery.isNotEmpty) {
          songs = songs.where((s) => s.title.toLowerCase().contains(searchQuery) || s.artist.toLowerCase().contains(searchQuery)).toList();
        }

        if (songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_for_offline_outlined, size: 64, color: Colors.grey[700]),
                const SizedBox(height: 16),
                const Text('No downloads found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

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
        child: CachedNetworkImage(
          imageUrl: song.albumArt, width: 50, height: 50, fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(width: 50, height: 50, color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white38)),
        ),
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(song.artist, maxLines: 1, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      trailing: IconButton(
        icon: Icon(
          isLiked ? Icons.favorite : (isDownloaded ? Icons.download_done : Icons.more_vert),
          color: (isLiked || isDownloaded) ? const Color(0xFF1DB954) : Colors.grey,
          size: 20,
        ),
        onPressed: () {
           SongOptionsSheet.show(context, song);
        },
      ),
      onTap: () {
        ref.read(playerNotifierProvider.notifier).playSong(song, queue: queue);
      },
    );
  }
}

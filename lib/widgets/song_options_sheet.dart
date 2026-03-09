import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../services/download_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SongOptionsSheet extends ConsumerStatefulWidget {
  final SongModel song;

  const SongOptionsSheet({Key? key, required this.song}) : super(key: key);

  static void show(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SongOptionsSheet(song: song),
    );
  }

  @override
  ConsumerState<SongOptionsSheet> createState() => _SongOptionsSheetState();
}

class _SongOptionsSheetState extends ConsumerState<SongOptionsSheet> {
  bool _isLiked = false;
  bool _isDownloaded = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() {
    final likedBox = Hive.box('liked_songs');
    final downloadsBox = Hive.box('downloads');
    if (mounted) {
      setState(() {
        _isLiked = likedBox.containsKey(widget.song.id);
        _isDownloaded = downloadsBox.containsKey(widget.song.id);
      });
    }
  }

  void _toggleLike() {
    final box = Hive.box('liked_songs');
    if (_isLiked) {
      box.delete(widget.song.id);
    } else {
      box.put(widget.song.id, widget.song.toMap());
    }
    setState(() => _isLiked = !_isLiked);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isLiked ? 'Added to Liked Songs' : 'Removed from Liked Songs')),
    );
  }

  Future<void> _handleDownload() async {
    if (_isDownloaded) {
      // Delete from downloads
      final box = Hive.box('downloads');
      final data = Map<String, dynamic>.from(box.get(widget.song.id) as Map);
      final localName = data['localPath'] as String?;
      if (localName != null) {
         try {
           final dir = await getApplicationDocumentsDirectory();
           final finalPath = localName.contains('/') ? '${dir.path}/download/${localName.split('/').last}' : '${dir.path}/download/$localName';
           final file = File(finalPath);
           if (await file.exists()) {
             await file.delete();
           }
         } catch(e) {
             debugPrint('Delete error: $e');
         }
      }
      await box.delete(widget.song.id);
      setState(() {
        _isDownloaded = false;
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from Downloads')));
      }
    } else {
      setState(() => _isDownloading = true);
      // Wait to pop until we start seeing the circular progress so they know it's working
      final service = DownloadService();
      // It's a background process ideally, but we'll await it while showing indicator inside bottom sheet
      final result = await service.downloadSong(widget.song);
      if (mounted) {
        setState(() => _isDownloading = false);
        Navigator.pop(context);
        if (result.startsWith('Error')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $result')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download complete!')));
        }
      }
    }
  }

  void _showPlaylists() {
    Navigator.pop(context); // close current sheet
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      builder: (ctx) {
        return ValueListenableBuilder<Box>(
          valueListenable: Hive.box('playlists').listenable(),
          builder: (context, box, _) {
            final playlists = box.values.cast<PlaylistModel>().toList();

            if (playlists.isEmpty) {
              return const Center(child: Text('No playlists. Create one first.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  leading: const Icon(Icons.queue_music, color: Colors.white),
                  title: Text(playlist.name),
                  onTap: () {
                    // Check if already in playlist
                    final exists = playlist.songs.any((s) => s.id == widget.song.id);
                    if (exists) {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already in ${playlist.name}')));
                    } else {
                       final updatedList = List<SongModel>.from(playlist.songs)..add(widget.song);
                       final updatedPlaylist = playlist.copyWith(songs: updatedList);
                       box.put(playlist.id, updatedPlaylist);
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${playlist.name}')));
                    }
                    Navigator.pop(ctx);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(widget.song.albumArt, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(widget.song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, color: Colors.white24),
          ListTile(
            leading: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? const Color(0xFF1DB954) : Colors.white),
            title: Text(_isLiked ? 'Liked' : 'Like'),
            onTap: _toggleLike,
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add, color: Colors.white),
            title: const Text('Add to Playlist'),
            onTap: _showPlaylists,
          ),
          ListTile(
            leading: _isDownloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1DB954)),
                  )
                : Icon(_isDownloaded ? Icons.download_done : Icons.download, color: _isDownloaded ? const Color(0xFF1DB954) : Colors.white),
            title: Text(_isDownloading ? 'Downloading...' : (_isDownloaded ? 'Remove Download' : 'Download')),
            onTap: _isDownloading ? null : _handleDownload, // Disable if currently downloading
          ),
        ],
      ),
    );
  }
}

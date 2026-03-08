import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/youtube_service.dart';
import '../models/song_model.dart';
import '../providers/player_provider.dart';
import 'dart:async';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final YoutubeService _yt = YoutubeService();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<SongModel> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final songs = await _yt.searchSongs(query);
      if (mounted) {
        setState(() {
          _results = songs;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'What do you want to listen to?',
                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final song = _results[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(song.albumArt, width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(song.artist, maxLines: 1),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    ref.read(playerNotifierProvider.notifier).playSong(song, queue: _results);
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

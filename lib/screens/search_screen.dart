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

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Podcasts', 'color': Colors.redAccent},
    {'title': 'Made For You', 'color': Colors.blueAccent},
    {'title': 'Charts', 'color': Colors.purpleAccent},
    {'title': 'New Releases', 'color': Colors.pinkAccent},
    {'title': 'Discover', 'color': Colors.teal},
    {'title': 'Radio', 'color': Colors.orangeAccent},
    {'title': 'Pop', 'color': Colors.greenAccent},
    {'title': 'Rock', 'color': Colors.indigoAccent},
    {'title': 'Hip-Hop', 'color': Colors.deepOrangeAccent},
    {'title': 'K-Pop', 'color': Colors.cyan},
  ];

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text('Search', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)))
                  : _controller.text.isEmpty
                      ? _buildBrowseAll()
                      : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseAll() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return InkWell(
          onTap: () {
            _controller.text = cat['title'];
            _onSearchChanged(cat['title']);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: cat['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              cat['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
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
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

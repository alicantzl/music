import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/youtube_service.dart';
import '../models/song_model.dart';
import '../providers/player_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/song_options_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final YoutubeService _yt = YoutubeService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  List<SongModel> _results = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasError = false;

  List<Map<String, dynamic>> get _categories {
    final region = ref.read(regionProvider);
    if (region == 'TR') {
      return [
        {'title': 'Türkçe Pop', 'color': Colors.pinkAccent},
        {'title': 'Arabesk', 'color': Colors.deepOrangeAccent},
        {'title': 'Türkçe Rap', 'color': Colors.indigoAccent},
        {'title': 'Türkçe Rock', 'color': Colors.teal},
        {'title': 'Slow Müzik', 'color': Colors.purpleAccent},
        {'title': 'Remix', 'color': Colors.orangeAccent},
        {'title': 'Akustik', 'color': Colors.greenAccent},
        {'title': 'Karadeniz', 'color': Colors.blueAccent},
        {'title': 'Podcast', 'color': Colors.redAccent},
        {'title': 'Özgün Müzik', 'color': Colors.cyan},
      ];
    }
    return [
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
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && !_isFetchingMore && _results.isNotEmpty) {
      _fetchMore();
    }
  }

  Future<void> _fetchMore() async {
    setState(() => _isFetchingMore = true);
    final moreSongs = await _yt.fetchMoreSearchResults();
    if (mounted) {
      setState(() {
        _results.addAll(moreSongs);
        _isFetchingMore = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
        _isFetchingMore = false;
        _hasError = false;
      });
      return;
    }

    setState(() { _isLoading = true; _hasError = false; });
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final currentQuery = query.trim();
      final songs = await _yt.searchSongs(currentQuery);
      if (mounted && _controller.text.trim() == currentQuery) {
        setState(() {
          _results = songs;
          _isLoading = false;
          _hasError = songs.isEmpty && currentQuery.isNotEmpty;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(localeProvider);

    // Reload categories when region changes
    ref.listen(regionProvider, (previous, next) {
      if (previous != next) {
        setState(() {});
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(t.search, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
                  hintText: t.searchHint,
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
                  : _hasError && _controller.text.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
                              const SizedBox(height: 16),
                              Text(t.noResults, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        )
                      : _controller.text.isEmpty
                          ? _buildBrowseAll(t)
                          : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseAll(LocalizedStrings t) {
    final cats = _categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(t.browseAll, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final cat = cats[index];
              return InkWell(
                onTap: () {
                  _controller.text = cat['title'];
                  _onSearchChanged('${cat['title']} music playlist official 2024 hits');
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
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _results.length + (_isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _results.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
          );
        }
        
        final song = _results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: song.albumArt, 
              width: 50, height: 50, fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(width: 50, height: 50, color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white38)),
            ),
          ),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(song.artist, maxLines: 1),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
               FocusScope.of(context).unfocus();
               SongOptionsSheet.show(context, song);
            },
          ),
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
    _scrollController.dispose();
    super.dispose();
  }
}

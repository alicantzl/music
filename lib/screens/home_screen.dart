import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import '../models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final YoutubeService _yt = YoutubeService();
  List<SongModel> _trending = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final songs = await _yt.getTrending();
    if (mounted) {
      setState(() {
        _trending = songs;
        _isLoading = false;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                _getGreeting(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              IconButton(icon: const Icon(Icons.history), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Access Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3,
                    ),
                    itemCount: _trending.length.clamp(0, 6),
                    itemBuilder: (context, index) {
                      final song = _trending[index];
                      return GestureDetector(
                        onTap: () => ref.read(playerNotifierProvider.notifier).playSong(song, queue: _trending.take(6).toList()),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: [
                              Image.network(song.albumArt, width: 56, height: 56, fit: BoxFit.cover),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  song.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Trending Hits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _trending.length,
                      itemBuilder: (context, index) {
                        final song = _trending[index];
                        return _buildLargeCard(song);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Based on your recent listening', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _trending.reversed.length,
                      itemBuilder: (context, index) {
                        final song = _trending.reversed.toList()[index];
                        return _buildSmallCard(song);
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Padding for mini player
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeCard(SongModel song) {
    return GestureDetector(
      onTap: () => ref.read(playerNotifierProvider.notifier).playSong(song, queue: _trending),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(song.albumArt, width: 150, height: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(SongModel song) {
    return GestureDetector(
      onTap: () => ref.read(playerNotifierProvider.notifier).playSong(song),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60), // Circular for Mixes style
              child: Image.network(song.albumArt, width: 120, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Center(child: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}

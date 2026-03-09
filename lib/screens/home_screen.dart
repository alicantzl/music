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
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final songs = await _yt.getTrending();
      if (mounted) {
        setState(() {
          _trending = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _play(SongModel song) {
    ref.read(playerNotifierProvider.notifier).playSong(song, queue: _trending);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF1DB954)),
              SizedBox(height: 16),
              Text('Loading music...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (_error != null || _trending.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text('Could not load music', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() { _isLoading = true; _error = null; });
                  _loadAll();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xFF1DB954),
        onRefresh: _loadAll,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              title: Text(
                _getGreeting(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
                IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
              ],
            ),

            // Quick Access Grid (top 6 songs as compact cards)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = _trending[index];
                    return GestureDetector(
                      onTap: () => _play(song),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF282828),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            Image.network(song.albumArt, width: 52, height: 52, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: 52, height: 52, color: Colors.grey[800],
                                    child: const Icon(Icons.music_note, size: 20, color: Colors.white38))),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                song.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _trending.length.clamp(0, 6),
                ),
              ),
            ),

            // Trending Hits Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: const Text('🔥 Trending Hits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _trending.length,
                  itemBuilder: (context, index) {
                    final song = _trending[index];
                    return GestureDetector(
                      onTap: () => _play(song),
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(song.albumArt, width: 150, height: 150, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                      width: 150, height: 150, color: Colors.grey[900],
                                      child: const Icon(Icons.music_note, size: 40, color: Colors.white24))),
                            ),
                            const SizedBox(height: 8),
                            Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 'Mixes' Section (circular artist cards)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: const Text('🎧 Made For You', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _trending.length,
                  itemBuilder: (context, index) {
                    final song = _trending.reversed.toList()[index];
                    return GestureDetector(
                      onTap: () => _play(song),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(song.albumArt, width: 120, height: 120, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                      width: 120, height: 120, color: Colors.grey[900],
                                      child: const Icon(Icons.person, size: 40, color: Colors.white24))),
                            ),
                            const SizedBox(height: 8),
                            Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // All songs as a list
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: const Text('📋 All Songs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = _trending[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(song.albumArt, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(song.artist, maxLines: 1, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_filled, color: Color(0xFF1DB954), size: 32),
                      onPressed: () => _play(song),
                    ),
                    onTap: () => _play(song),
                  );
                },
                childCount: _trending.length,
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_service/audio_service.dart';
import '../providers/player_provider.dart';
import '../providers/settings_provider.dart';
import '../models/song_model.dart';
import '../services/download_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/song_options_sheet.dart';
import '../widgets/add_to_playlist_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final DownloadService _downloadService = DownloadService();
  bool _isDownloading = false;

  VideoPlayerController? _videoController;
  final PageController _pageController = PageController();
  bool _isVideoLoading = false;
  String? _loadedVideoId;

  // Sleep Timer
  Timer? _sleepTimer;
  int? _sleepMinutesRemaining;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _disposeVideo() {
    _videoController?.dispose();
    _videoController = null;
    _loadedVideoId = null;
  }

  Future<void> _loadVideo(String videoId) async {
    if (_loadedVideoId == videoId && _videoController != null) {
      _videoController?.play();
      return;
    }
    setState(() => _isVideoLoading = true);
    
    try {
      final yt = YoutubeExplode();
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = manifest.muxed.withHighestBitrate();
      final url = streamInfo.url.toString();
      yt.close();

      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      await _videoController!.setVolume(0);
      _videoController!.setLooping(true);
      _loadedVideoId = videoId;
      
      if (mounted) {
        setState(() => _isVideoLoading = false);
        if (_pageController.hasClients && _pageController.page == 1) {
          final isPlaying = ref.read(isPlayingProvider);
          final currentPos = ref.read(positionProvider).value ?? Duration.zero;
          _videoController!.seekTo(currentPos);
          if (isPlaying) {
            _videoController!.play();
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isVideoLoading = false);
      debugPrint("Video load error: $e");
    }
  }

  void _showSleepTimerSheet() {
    final t = ref.read(localeProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(t.sleepTimer,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            ...[15, 30, 45, 60].map((mins) => ListTile(
              leading: const Icon(Icons.timer, color: Colors.white70),
              title: Text('$mins ${t == LocalizedStrings.tr ? "dakika" : "minutes"}',
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                _startSleepTimer(mins);
                Navigator.pop(ctx);
              },
            )),
            if (_sleepTimer != null)
              ListTile(
                leading: const Icon(Icons.timer_off, color: Colors.redAccent),
                title: Text(t.sleepTimerOff, style: const TextStyle(color: Colors.redAccent)),
                onTap: () {
                  _cancelSleepTimer();
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    setState(() => _sleepMinutesRemaining = minutes);
    _sleepTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _sleepMinutesRemaining = _sleepMinutesRemaining! - 1;
          if (_sleepMinutesRemaining! <= 0) {
            ref.read(playerNotifierProvider.notifier).pause();
            _cancelSleepTimer();
          }
        });
      }
    });
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    if (mounted) setState(() => _sleepMinutesRemaining = null);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _openPlaylistPopup(SongModel song) {
    AddToPlaylistSheet.show(context, song);
  }

  Future<void> _download(SongModel song) async {
    setState(() => _isDownloading = true);
    final result = await _downloadService.downloadSong(song);
    if (mounted) {
      setState(() => _isDownloading = false);
      final isSuccess = !result.startsWith('Error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSuccess ? '✅ Downloaded!' : '❌ $result',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: isSuccess ? const Color(0xFF1DB954) : Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(currentSongProvider).value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final processingState = ref.watch(processingStateProvider);
    final isBuffering = processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering;

    // Listen to play/pause state independently
    ref.listen(isPlayingProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page == 1) {
        if (next) {
          _videoController?.play();
        } else {
          _videoController?.pause();
        }
      }
    });

    // Sync video position when drifting occurs
    ref.listen(positionProvider, (previous, next) {
      final pos = next.value;
      if (pos != null && _videoController != null && _pageController.hasClients && _pageController.page == 1) {
         final diff = (pos - _videoController!.value.position).inMilliseconds.abs();
         if (diff > 1500) {
            _videoController!.seekTo(pos);
         }
      }
    });

    // Listen to song changes – dispose old video, load new if on video page
    ref.listen(currentSongProvider, (previous, next) {
      final nextSong = next.value;
      if (nextSong != null && previous?.value?.id != nextSong.id) {
        _disposeVideo();
        if (_pageController.hasClients && _pageController.page == 1) {
          _loadVideo(nextSong.id);
        }
      }
    });

    if (song == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_off, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text('No song playing', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final isLiked = Hive.box('liked_songs').containsKey(song.id);
    final isDownloaded = Hive.box('downloads').containsKey(song.id) || song.isDownloaded;
    final maxDur = song.duration.inSeconds > 0 ? song.duration.inSeconds.toDouble() : 1.0;
    final curPos = position.inSeconds.toDouble().clamp(0.0, maxDur);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dismissible(
        key: const Key('player_dismiss_key'),
        direction: DismissDirection.down,
        onDismissed: (_) => context.pop(),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < -300) {
              ref.read(playerNotifierProvider.notifier).skipToNext();
            } else if (details.primaryVelocity! > 300) {
              ref.read(playerNotifierProvider.notifier).skipToPrevious();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Blurred background
              CachedNetworkImage(
                imageUrl: song.albumArt, fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),

              // Content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.white),
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('PLAYING FROM',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.white60)),
                                Text(song.artist,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {
                             SongOptionsSheet.show(context, song);
                          }),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Album art + Video with PageView
                      SizedBox(
                        height: MediaQuery.of(context).size.width - 80,
                        width: MediaQuery.of(context).size.width - 80,
                        child: PageView(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            if (index == 1) {
                              _loadVideo(song.id);
                              final currentPos = ref.read(positionProvider).value ?? Duration.zero;
                              _videoController?.seekTo(currentPos);
                              if (ref.read(isPlayingProvider)) {
                                _videoController?.play();
                              }
                            } else {
                              _videoController?.pause();
                            }
                          },
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, spreadRadius: 5)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: song.albumArt,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[900],
                                    child: const Icon(Icons.music_note, size: 80, color: Colors.white38),
                                  ),
                                ),
                              ),
                            ),
                            // Video page with thumbnail background
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Thumbnail background
                                  if (!_isVideoLoading && (_videoController == null || !_videoController!.value.isInitialized))
                                    CachedNetworkImage(
                                      imageUrl: song.albumArt,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Container(color: Colors.black),
                                    ),
                                  // Dark overlay on thumbnail
                                  if (!_isVideoLoading && (_videoController == null || !_videoController!.value.isInitialized))
                                    Container(color: Colors.black.withOpacity(0.4)),
                                  
                                  // Video or loading indicator
                                  if (_isVideoLoading)
                                    const Center(child: CircularProgressIndicator(color: Colors.white))
                                  else if (_videoController != null && _videoController!.value.isInitialized)
                                    SizedBox.expand(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _videoController!.value.size.width,
                                          height: _videoController!.value.size.height,
                                          child: VideoPlayer(_videoController!),
                                        ),
                                      ),
                                    )
                                  else
                                    const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.play_circle_outline, color: Colors.white54, size: 48),
                                          SizedBox(height: 8),
                                          Text('Swipe to load clip', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      
                      if (processingState == AudioProcessingState.error)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Stream unavailable. Could not load.', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                        ),

                      const SizedBox(height: 32),

                      // Song info + like
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(song.title,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(song.artist, style: const TextStyle(fontSize: 16, color: Colors.white60),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? const Color(0xFF1DB954) : Colors.white, size: 28),
                            onPressed: () => _openPlaylistPopup(song),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Seek bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          min: 0,
                          max: maxDur,
                          value: curPos,
                          onChanged: (v) => ref.read(playerNotifierProvider.notifier).seekTo(Duration(seconds: v.toInt())),
                        ),
                      ),

                      // Time labels
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_fmt(position), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            Text(_fmt(song.duration), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Controls with Glassmorphism
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Consumer(
                                  builder: (context, ref, _) {
                                    final isShuffle = ref.watch(shuffleModeProvider);
                                    final repeatMode = ref.watch(repeatModeProvider);
                                    
                                    IconData icon;
                                    Color color;
                                    
                                    if (repeatMode == AudioServiceRepeatMode.one) {
                                      icon = Icons.repeat_one_rounded;
                                      color = const Color(0xFF1DB954);
                                    } else if (isShuffle) {
                                      icon = Icons.shuffle_rounded;
                                      color = const Color(0xFF1DB954);
                                    } else if (repeatMode == AudioServiceRepeatMode.all) {
                                      icon = Icons.repeat_rounded;
                                      color = const Color(0xFF1DB954);
                                    } else {
                                      icon = Icons.shuffle_rounded;
                                      color = Colors.white60;
                                    }

                                    return IconButton(
                                      icon: Icon(icon, color: color, size: 22),
                                      onPressed: () {
                                        if (!isShuffle && repeatMode == AudioServiceRepeatMode.none) {
                                          ref.read(playerNotifierProvider.notifier).toggleShuffle(); // -> Shuffle
                                        } else if (isShuffle) {
                                          ref.read(playerNotifierProvider.notifier).toggleShuffle(); // Shuffle off
                                          ref.read(playerNotifierProvider.notifier).cycleRepeatMode(); // -> Repeat All
                                        } else if (repeatMode == AudioServiceRepeatMode.all) {
                                          ref.read(playerNotifierProvider.notifier).cycleRepeatMode(); // -> Repeat One
                                        } else {
                                          ref.read(playerNotifierProvider.notifier).cycleRepeatMode(); // -> None
                                        }
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_previous_rounded, size: 42, color: Colors.white),
                                  onPressed: () => ref.read(playerNotifierProvider.notifier).skipToPrevious(),
                                ),
                                // Play/Pause
                                GestureDetector(
                                  onTap: isBuffering ? null : () => ref.read(playerNotifierProvider.notifier).togglePlayPause(),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                    child: isBuffering
                                        ? const Padding(
                                            padding: EdgeInsets.all(16),
                                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                                          )
                                        : Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: Colors.black, size: 40),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next_rounded, size: 42, color: Colors.white),
                                  onPressed: () => ref.read(playerNotifierProvider.notifier).skipToNext(),
                                ),
                                _isDownloading
                                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : IconButton(
                                        icon: Icon(isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                                            color: isDownloaded ? const Color(0xFF1DB954) : Colors.white60, size: 22),
                                        onPressed: isDownloaded ? null : () => _download(song),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sleep Timer button
                      GestureDetector(
                        onTap: _showSleepTimerSheet,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bedtime_rounded,
                              color: _sleepMinutesRemaining != null ? const Color(0xFF1DB954) : Colors.white38,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _sleepMinutesRemaining != null
                                  ? '${_sleepMinutesRemaining} min'
                                  : (ref.read(localeProvider).sleepTimer),
                              style: TextStyle(
                                color: _sleepMinutesRemaining != null ? const Color(0xFF1DB954) : Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

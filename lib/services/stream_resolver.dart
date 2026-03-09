import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ResolvedStream {
  final String? url;
  final StreamInfo? info;
  ResolvedStream({this.url, this.info});
}

class StreamResolver {
  static final YoutubeExplode _yt = YoutubeExplode();
  
  // We strictly use Video IDs now. Name cleaning is deprecated as fuzzy search is removed.

  static Future<ResolvedStream?> resolve(String videoId, {String? title, String? artist, bool dataSaver = false}) async {
    debugPrint('[StreamResolver] 🎵 Starting Resolution: $videoId');
    
    // --- EXCLUSIVE SOURCE: YouTube (Direct and Reliable) ---
    try {
      // Speed optimization: Using ONLY iOS client to avoid multiple slow handshakes
      // and reducing timeout to 5s for snappy feel.
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.ios,
      ]).timeout(const Duration(seconds: 5));
      
      // Speed optimization: Prioritize Audio-Only (M4A) because it's ~80% smaller than Muxed.
      // This is the key to fixing the 6-7s wait time.
      final audioStreams = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (audioStreams.isNotEmpty) {
        audioStreams.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ Fast Audio-Only selected ($videoId)');
        return ResolvedStream(url: audioStreams.first.url.toString(), info: audioStreams.first);
      }

      // Fallback only if no audio-only remains
      final muxed = manifest.muxed
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (muxed.isNotEmpty) {
        muxed.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube Muxed Stream fallback ($videoId)');
        return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
      }
    } catch (e) {
      debugPrint('[StreamResolver] ❌ YouTube direct fetch failed for $videoId: $e');
    }

    return null;
  }
}

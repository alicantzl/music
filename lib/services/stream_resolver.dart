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
    // We removed external fallbacks (JioSaavn) because they often returned incorrect songs
    // for specific artists/regions, causing the "Wrong Song" issue.
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.ios,
        YoutubeApiClient.android,
      ]).timeout(const Duration(seconds: 12));
      
      // Since video player works perfectly with muxed streams, we try muxed first for max reliability
      final muxed = manifest.muxed
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();
          
      if (muxed.isNotEmpty) {
        muxed.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube Muxed Stream selected ($videoId)');
        return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
      }

      // Fallback to audio-only if muxed not available
      final audioStreams = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (audioStreams.isNotEmpty) {
        audioStreams.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube Audio-Only fallback ($videoId)');
        return ResolvedStream(url: audioStreams.first.url.toString(), info: audioStreams.first);
      } 
    } catch (e) {
      debugPrint('[StreamResolver] ❌ YouTube direct fetch failed for $videoId: $e');
    }

    return null;
  }
}

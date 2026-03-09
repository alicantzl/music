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
  
  static String _cleanString(String text) {
    var cleaned = text.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'(official|audio|video|music|lyric|lyrics|hq|hd|4k|8k|remix|edit|-)', caseSensitive: false), '');
    // Allow Turkish specific characters + alphanumeric
    cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9 öüşçğıİÖÜŞÇĞ ]'), ' ');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static Future<ResolvedStream?> resolve(String videoId, {String? title, String? artist, bool dataSaver = false}) async {
    debugPrint('[StreamResolver] 🎵 Starting Resolution: $videoId');
    
    // --- 1. PRIORITY SOURCE: YouTube (Direct and Reliable) ---
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.ios,
        YoutubeApiClient.android,
      ]).timeout(const Duration(seconds: 8));
      
      // Try audio-only first (lighter)
      final audioStreams = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (audioStreams.isNotEmpty) {
        audioStreams.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube Audio-Only found');
        return ResolvedStream(url: audioStreams.first.url.toString(), info: audioStreams.first);
      } 
      
      // Fallback to muxed (video+audio) – this is what player_screen uses and it works!
      final muxed = manifest.muxed
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();
      if (muxed.isNotEmpty) {
        muxed.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube Muxed Stream fallback');
        return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
      }
    } catch (e) {
      debugPrint('[StreamResolver] ⚠️ YouTube direct fetch failed: $e');
    }

    // --- 2. SECONDARY SOURCE: JioSaavn Mirrors (Fallback for potentially higher bitrate) ---
    if (title != null && title.isNotEmpty) {
      debugPrint('[StreamResolver] 🔍 Trying JioSaavn fallback for: $title');
      final cleanT = _cleanString(title);
      final cleanA = _cleanString(artist ?? '');
      final query = Uri.encodeComponent('$cleanT $cleanA');
      
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 3);
        
        final mirrors = [
          'https://jiosaavn-api-privatecvc2.vercel.app',
          'https://music-api.up.railway.app',
        ];
        
        for (var mirror in mirrors) {
          try {
            final sreq = await client.getUrl(Uri.parse('$mirror/search/songs?query=$query'));
            final sres = await sreq.close().timeout(const Duration(seconds: 3));
            
            if (sres.statusCode == 200) {
              final body = await sres.transform(utf8.decoder).join();
              final data = json.decode(body);
              final results = data['data']['results'] as List;
              if (results.isNotEmpty) {
                final first = results.first;
                final saavnName = (first['name'] as String).toLowerCase();
                if (saavnName.contains(cleanT.split(' ').first.toLowerCase())) {
                   final saavnId = first['id'];
                   final dreq = await client.getUrl(Uri.parse('$mirror/songs?id=$saavnId'));
                   final dres = await dreq.close().timeout(const Duration(seconds: 3));
                   if (dres.statusCode == 200) {
                     final dbody = await dres.transform(utf8.decoder).join();
                     final ddata = json.decode(dbody);
                     final list = ddata['data'] as List;
                     final durlList = list.first['downloadUrl'] as List;
                     final url = dataSaver ? durlList.first['link'].toString() : durlList.last['link'].toString();
                     client.close();
                     debugPrint('[StreamResolver] ✅ JioSaavn fallback SUCCESS');
                     return ResolvedStream(url: url);
                   }
                }
              }
            }
          } catch (_) {}
        }
        client.close();
      } catch (_) {}
    }

    debugPrint('[StreamResolver] ❌ All sources failed for $videoId');
    return null;
  }
}

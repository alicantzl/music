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
  
  static Future<ResolvedStream?> resolve(String videoId, {String? title, String? artist, bool dataSaver = false}) async {
    debugPrint('[StreamResolver] Resolving: $videoId (title=$title, artist=$artist)');
    
    // 1. YouTube Direct Resolution (Reliable & Fast fallback)
    // AudioHandler relies on this if anything else fails.
    Future<ResolvedStream?> resolveYouTube() async {
      try {
        final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
          YoutubeApiClient.android,
          YoutubeApiClient.ios,
          YoutubeApiClient.web, // Add web client for more reliability
        ]).timeout(const Duration(seconds: 6));
        
        final audioStreams = manifest.audioOnly
            .where((s) => s.container.name.toLowerCase() == 'mp4')
            .toList();

        if (audioStreams.isNotEmpty) {
          audioStreams.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
          return ResolvedStream(url: audioStreams.first.url.toString(), info: audioStreams.first);
        } else if (manifest.muxed.isNotEmpty) {
          final muxed = manifest.muxed
              .where((s) => s.container.name.toLowerCase() == 'mp4')
              .toList();
          if (muxed.isNotEmpty) {
            muxed.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
            return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
          }
        }
      } catch (e) {
        debugPrint('[StreamResolver] YouTube direct fetch failed: $e');
      }
      return null;
    }

    // 2. Try JioSaavn ONLY IF we have correct title/artist and it's not a heavy load
    if (title != null && title.isNotEmpty) {
      final cleanT = _cleanString(title);
      final cleanA = _cleanString(artist ?? '');
      final query = Uri.encodeComponent('$cleanT $cleanA');
      
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 3); // Faster timeout
        
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
                // Strict validation to avoid mismatch
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
                     debugPrint('[StreamResolver] Success via JioSaavn Mirror');
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

    // 3. Ultimate Fallback: Direct YouTube Stream
    debugPrint('[StreamResolver] Mirror failed or skipped, falling back to direct YT...');
    return await resolveYouTube();
  }
}

    return null; 
  }
}

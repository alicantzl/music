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
    cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static Future<ResolvedStream?> resolve(String videoId) async {
    debugPrint('Resolving YouTube video: $videoId');
    
    // 1. Fetch metadata to extract title and author
    try {
      final video = await _yt.videos.get(VideoId(videoId));
      final title = _cleanString(video.title);
      final author = _cleanString(video.author.replaceAll(RegExp(r'VEVO', caseSensitive: false), ''));
      final query = Uri.encodeComponent('$title $author');
      
      debugPrint('JioSaavn Search Query: $title $author');
      
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);
      
      // Use verified JioSaavn API mirrors
      final mirrors = [
        'https://jiosaavn-api-privatecvc2.vercel.app',
        'https://music-api.up.railway.app',
        'https://jiosaavn-api-v3.vercel.app',
      ];
      
      for (var mirror in mirrors) {
        try {
          final sreq = await client.getUrl(Uri.parse('$mirror/search/songs?query=$query'));
          sreq.headers.add('User-Agent', 'Mozilla/5.0');
          final sres = await sreq.close().timeout(const Duration(seconds: 5));
          
          if (sres.statusCode == 200) {
            final body = await sres.transform(utf8.decoder).join();
            final data = json.decode(body);
            final results = data['data']['results'] as List;
            
            if (results.isNotEmpty) {
              final saavnId = results.first['id'];
              final name = results.first['name'];
              debugPrint('JioSaavn Match found: $name (ID: $saavnId)');
              
              final dreq = await client.getUrl(Uri.parse('$mirror/songs?id=$saavnId'));
              dreq.headers.add('User-Agent', 'Mozilla/5.0');
              final dres = await dreq.close().timeout(const Duration(seconds: 5));
              
              if (dres.statusCode == 200) {
                final dbody = await dres.transform(utf8.decoder).join();
                final ddata = json.decode(dbody);
                final list = ddata['data'] as List;
                final dlist = list.first['downloadUrl'] as List;
                
                // prefer 320kbps (last item usually)
                final url = dlist.last['link'].toString();
                debugPrint('Resolved High-Quality Audio URL from JioSaavn!');
                return ResolvedStream(url: url);
              }
            }
          }
        } catch (e) {
          debugPrint('JioSaavn Mirror $mirror failed: $e');
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch YouTube metadata: $e');
    }

    // 2. Fallback to youtube_explode_dart stream extraction
    // This rarely works on mobile anymore due to YouTube's strict anti-bot 403s!
    debugPrint('Falling back to youtube_explode_dart direct stream...');
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.ios,
      ]).timeout(const Duration(seconds: 5));
      
      final mp4AudioOnly = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').toList();

      if (mp4AudioOnly.isNotEmpty) {
        mp4AudioOnly.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        return ResolvedStream(url: mp4AudioOnly.first.url.toString(), info: mp4AudioOnly.first);
      } else if (manifest.muxed.isNotEmpty) {
        final muxed = manifest.muxed.where((s) => s.container.name.toLowerCase() == 'mp4').toList();
        if (muxed.isNotEmpty) {
           muxed.sort((a, b) => b.bitrate.compareTo(a.bitrate));
           return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
        }
      }
    } catch (e) {
      debugPrint('youtube_explode_dart fallback failed: $e');
    }

    return null; 
  }
}

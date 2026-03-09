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
    debugPrint('[StreamResolver] Resolving: $videoId (title=$title, artist=$artist)');
    
    String searchTitle = title ?? '';
    String searchArtist = artist ?? '';

    // 1. If we have a direct title/artist, try JioSaavn for potentially higher quality/CDN
    if (searchTitle.isNotEmpty) {
      final cleanT = _cleanString(searchTitle);
      final cleanA = _cleanString(searchArtist.replaceAll(RegExp(r'VEVO', caseSensitive: false), ''));
      final query = Uri.encodeComponent('$cleanT $cleanA');
      
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 4);
        
        final mirrors = [
          'https://jiosaavn-api-privatecvc2.vercel.app',
          'https://music-api.up.railway.app',
        ];
        
        for (var mirror in mirrors) {
          try {
            final sreq = await client.getUrl(Uri.parse('$mirror/search/songs?query=$query'));
            final sres = await sreq.close().timeout(const Duration(seconds: 4));
            
            if (sres.statusCode == 200) {
              final body = await sres.transform(utf8.decoder).join();
              final data = json.decode(body);
              final results = data['data']['results'] as List;
              if (results.isNotEmpty) {
                final first = results.first;
                // Basic validation: must contain part of the title
                final saavnName = (first['name'] as String).toLowerCase();
                if (saavnName.contains(cleanT.split(' ').first.toLowerCase())) {
                   final saavnId = first['id'];
                   final dreq = await client.getUrl(Uri.parse('$mirror/songs?id=$saavnId'));
                   final dres = await dreq.close().timeout(const Duration(seconds: 4));
                   if (dres.statusCode == 200) {
                     final dbody = await dres.transform(utf8.decoder).join();
                     final ddata = json.decode(dbody);
                     final list = ddata['data'] as List;
                     final durlList = list.first['downloadUrl'] as List;
                     final url = dataSaver ? durlList.first['link'].toString() : durlList.last['link'].toString();
                     client.close();
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

    // 2. Fallback or Direct: youtube_explode_dart using the EXACT videoId
    // This solves the mismatch because we are using the ID the user actually chose.
    debugPrint('[StreamResolver] Falling back to YouTube direct stream for $videoId');
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.ios,
      ]).timeout(const Duration(seconds: 8));
      
      final mp4AudioOnly = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (mp4AudioOnly.isNotEmpty) {
        mp4AudioOnly.sort((a, b) => dataSaver ? a.bitrate.compareTo(b.bitrate) : b.bitrate.compareTo(a.bitrate));
        return ResolvedStream(url: mp4AudioOnly.first.url.toString(), info: mp4AudioOnly.first);
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
      debugPrint('[StreamResolver] YouTube fallback failed: $e');
    }

    return null; 
  }
}

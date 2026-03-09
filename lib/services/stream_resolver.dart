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

  static Future<ResolvedStream?> resolve(String videoId, {String? title, String? artist}) async {
    debugPrint('[StreamResolver] Resolving: $videoId (title=$title, artist=$artist)');
    
    String searchTitle = title ?? '';
    String searchArtist = artist ?? '';

    // 1. Fetch metadata from YouTube if not provided
    if (searchTitle.isEmpty) {
      try {
        final video = await _yt.videos.get(VideoId(videoId));
        searchTitle = _cleanString(video.title);
        searchArtist = _cleanString(video.author.replaceAll(RegExp(r'VEVO', caseSensitive: false), ''));
      } catch (e) {
        debugPrint('[StreamResolver] YouTube metadata fetch failed: $e');
        return null;
      }
    } else {
      searchTitle = _cleanString(searchTitle);
      searchArtist = _cleanString(searchArtist.replaceAll(RegExp(r'VEVO', caseSensitive: false), ''));
    }

    // 2. Search JioSaavn mirrors in parallel
    final query = Uri.encodeComponent('$searchTitle $searchArtist');
    debugPrint('[StreamResolver] JioSaavn search: "$searchTitle $searchArtist"');
    
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      
      final mirrors = [
        'https://jiosaavn-api-privatecvc2.vercel.app',
        'https://music-api.up.railway.app',
        'https://jiosaavn-api-v3.vercel.app',
      ];
      
      // Search all mirrors in parallel, return first match
      final searchResults = await Future.wait(mirrors.map((mirror) async {
        try {
          final sreq = await client.getUrl(Uri.parse('$mirror/search/songs?query=$query'));
          sreq.headers.add('User-Agent', 'Mozilla/5.0');
          final sres = await sreq.close().timeout(const Duration(seconds: 5));
          
          if (sres.statusCode == 200) {
            final body = await sres.transform(utf8.decoder).join();
            final data = json.decode(body);
            final results = data['data']['results'] as List;
            if (results.isNotEmpty) {
              debugPrint('[StreamResolver] Mirror $mirror found: ${results.first['name']}');
              return {'mirror': mirror, 'id': results.first['id']};
            }
          }
        } catch (_) {}
        return null;
      }));

      final firstMatch = searchResults.firstWhere((r) => r != null, orElse: () => null);
      
      if (firstMatch != null) {
        final mirror = firstMatch['mirror'];
        final saavnId = firstMatch['id'];
        debugPrint('[StreamResolver] Fetching song detail from $mirror (id=$saavnId)');
        
        try {
          final dreq = await client.getUrl(Uri.parse('$mirror/songs?id=$saavnId'));
          dreq.headers.add('User-Agent', 'Mozilla/5.0');
          final dres = await dreq.close().timeout(const Duration(seconds: 5));
          
          if (dres.statusCode == 200) {
            final dbody = await dres.transform(utf8.decoder).join();
            // *** CRITICAL FIX: was json.decode(body) — 'body' was out of scope! ***
            // Now correctly decoding 'dbody' which is the detail response.
            final ddata = json.decode(dbody);
            final list = ddata['data'] as List;
            final dlist = list.first['downloadUrl'] as List;
            final url = dlist.last['link'].toString();
            debugPrint('[StreamResolver] ✅ GOT SAAVN URL: $url');
            client.close();
            return ResolvedStream(url: url);
          } else {
            debugPrint('[StreamResolver] Detail fetch HTTP ${dres.statusCode}');
          }
        } catch (e) {
          debugPrint('[StreamResolver] Saavn detail fetch error: $e');
        }
      } else {
        debugPrint('[StreamResolver] No match found on any JioSaavn mirror');
      }
      
      client.close();
    } catch (e) {
      debugPrint('[StreamResolver] JioSaavn search error: $e');
    }

    // 3. Fallback: youtube_explode_dart direct stream
    debugPrint('[StreamResolver] Falling back to YouTube direct stream...');
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.ios,
      ]).timeout(const Duration(seconds: 6));
      
      final mp4AudioOnly = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      if (mp4AudioOnly.isNotEmpty) {
        mp4AudioOnly.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        debugPrint('[StreamResolver] ✅ YouTube audio-only stream found');
        return ResolvedStream(url: mp4AudioOnly.first.url.toString(), info: mp4AudioOnly.first);
      } else if (manifest.muxed.isNotEmpty) {
        final muxed = manifest.muxed
            .where((s) => s.container.name.toLowerCase() == 'mp4')
            .toList();
        if (muxed.isNotEmpty) {
          muxed.sort((a, b) => b.bitrate.compareTo(a.bitrate));
          debugPrint('[StreamResolver] ✅ YouTube muxed stream found');
          return ResolvedStream(url: muxed.first.url.toString(), info: muxed.first);
        }
      }
    } catch (e) {
      debugPrint('[StreamResolver] YouTube fallback failed: $e');
    }

    debugPrint('[StreamResolver] ❌ All sources failed for $videoId');
    return null; 
  }
}

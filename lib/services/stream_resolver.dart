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
  
  static const List<String> _pipedInstances = [
    'https://pipedapi.kavin.rocks',
    'https://pipedapi.tokhmi.xyz',
    'https://pipedapi.syncpundit.io',
    'https://api.piped.moe'
  ];

  static Future<ResolvedStream?> resolve(String videoId) async {
    for (final instance in _pipedInstances) {
      try {
        debugPrint('Trying Piped API ($instance) for $videoId...');
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse('$instance/streams/$videoId'))
            .timeout(const Duration(seconds: 4));
        final response = await request.close();
        
        if (response.statusCode == 200) {
          final body = await response.transform(utf8.decoder).join();
          final data = json.decode(body);
          final audioStreams = data['audioStreams'] as List;
          
          if (audioStreams.isNotEmpty) {
            final m4aStreams = audioStreams.where((s) => s['format'] == 'M4A').toList();
            if (m4aStreams.isNotEmpty) {
               m4aStreams.sort((a, b) => (b['bitrate'] as int).compareTo(a['bitrate'] as int));
               debugPrint('Success: Found Piped stream!');
               return ResolvedStream(url: m4aStreams.first['url'] as String);
            }
          }
        }
      } catch (e) {
        debugPrint('Piped backend $instance failed: $e');
      }
    }

    debugPrint('All Piped APIs failed, falling back to youtube_explode_dart...');
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final mp4AudioOnly = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').toList();

      if (mp4AudioOnly.isNotEmpty) {
        mp4AudioOnly.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        return ResolvedStream(info: mp4AudioOnly.first);
      } else if (manifest.muxed.isNotEmpty) {
        final muxed = manifest.muxed.where((s) => s.container.name.toLowerCase() == 'mp4').toList();
        if (muxed.isNotEmpty) {
           muxed.sort((a, b) => b.bitrate.compareTo(a.bitrate));
           return ResolvedStream(info: muxed.first);
        }
      }
    } catch (e) {
      debugPrint('youtube_explode_dart fallback failed: $e');
    }

    return null; 
  }
}

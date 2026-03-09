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
  
  static Future<ResolvedStream?> resolve(String videoId) async {
    debugPrint('Resolving YouTube URL directly with explode_dart...');
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
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

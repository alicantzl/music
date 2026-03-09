import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomProxyAudioSource extends StreamAudioSource {
  final StreamInfo? streamInfo;
  final String? directUrl;
  final YoutubeExplode yt;
  final String id;
  
  CustomProxyAudioSource({
    required this.id,
    required this.yt,
    this.streamInfo,
    this.directUrl,
  });

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // 1. If we have a Piped direct URL, we can stream directly via Http
    if (directUrl != null) {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(directUrl!));
      request.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
      if (start != null || end != null) {
        request.headers.add('Range', 'bytes=${start ?? 0}-${end ?? ""}');
      }
      final response = await request.close();
      return StreamAudioResponse(
        sourceLength: response.contentLength >= 0 ? response.contentLength : null,
        contentLength: response.contentLength >= 0 ? response.contentLength : null,
        offset: start ?? 0,
        stream: response,
        contentType: 'audio/mp4',
      );
    } 

    // 2. If we fallback to youtube_explode_dart StreamInfo, 
    // pipe it explicitly so it decrypts "n" ciphers properly
    else if (streamInfo != null) {
      // NOTE: youtube_explode_dart's get() stream handles YouTube's throttling!
      final stream = yt.videos.streamsClient.get(streamInfo!);
      return StreamAudioResponse(
        sourceLength: streamInfo!.size.totalBytes,
        contentLength: streamInfo!.size.totalBytes,
        offset: 0,
        stream: stream,
        contentType: 'audio/mp4',
      );
    }
    
    throw Exception('No stream available');
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'stream_resolver.dart';

class CustomProxyAudioSource extends StreamAudioSource {
  final ResolvedStream resolved;
  final String id;
  
  CustomProxyAudioSource({
    required this.id,
    required this.resolved,
  });

  static final HttpClient _client = HttpClient()..connectionTimeout = const Duration(seconds: 10);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final url = resolved.url ?? resolved.info?.url.toString();
    if (url == null) throw Exception('No URL provided');
    
    final request = await _client.getUrl(Uri.parse(url));
    
    // Always provide a User-Agent that YouTube likes
    request.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
    request.headers.add('Referer', 'https://www.youtube.com/');
    
    // YouTube blocks Android requests without Range headers
    final rangeStart = start ?? 0;
    final rangeEnd = end != null ? '$end' : '';
    request.headers.add('Range', 'bytes=$rangeStart-$rangeEnd');
    
    final response = await request.close();
    
    if (response.statusCode >= 400) {
      debugPrint('Proxy Error: HTTP \${response.statusCode}');
      throw Exception('HTTP \${response.statusCode}');
    }

    return StreamAudioResponse(
      sourceLength: resolved.info?.size.totalBytes ?? response.contentLength,
      contentLength: response.contentLength >= 0 ? response.contentLength : null,
      offset: rangeStart,
      stream: response,
      contentType: 'audio/mp4',
    );
  }
}

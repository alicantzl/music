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
    
    // YouTube blocks Android requests without Range headers
    final rangeStart = start ?? 0;
    final rangeEnd = end != null ? '$end' : '';

    final response = await _client.getUrl(Uri.parse(url)).then((req) {
      // Always provide a User-Agent that YouTube likes
      req.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
      req.headers.add('Referer', 'https://www.youtube.com/');
      req.headers.add('Range', 'bytes=$rangeStart-$rangeEnd');
      return req.close();
    });

    if (response.statusCode >= 400) {
      debugPrint('Proxy Error: HTTP ${response.statusCode}');
      throw Exception('HTTP ${response.statusCode}');
    }

    int? totalLength = resolved.info?.size.totalBytes;
    if (totalLength == null) {
      final contentRange = response.headers.value('content-range');
      if (contentRange != null) {
        // format: bytes start-end/total
        final totalStr = contentRange.split('/').last;
        totalLength = int.tryParse(totalStr);
      }
    }
    
    // If still null, use contentLength as fallback (might be wrong for 206 but it's all we have)
    totalLength ??= response.contentLength >= 0 ? response.contentLength : null;

    return StreamAudioResponse(
      sourceLength: totalLength,
      contentLength: response.contentLength >= 0 ? response.contentLength : null,
      offset: rangeStart,
      stream: response,
      contentType: 'audio/mp4',
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class ProxyAudioSource extends StreamAudioSource {
  final String streamUrl;
  final String id;
  
  ProxyAudioSource(this.streamUrl, this.id);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(streamUrl));

    // Must masquerade as a real browser
    request.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
    request.headers.add('Accept', '*/*');
    
    // Add Range header for streaming buffer
    if (start != null || end != null) {
      request.headers.add('Range', 'bytes=${start ?? 0}-${end ?? ""}');
    }

    final response = await request.close();
    
    return StreamAudioResponse(
      sourceLength: response.contentLength >= 0 ? response.contentLength : null,
      contentLength: response.contentLength >= 0 ? response.contentLength : null,
      offset: start ?? 0,
      stream: response,
      contentType: response.headers.contentType?.toString() ?? 'audio/mp4',
    );
  }
}

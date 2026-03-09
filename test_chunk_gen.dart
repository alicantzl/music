import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Stream<List<int>> chunkedStream(String url, int start, int? end, int totalSize) async* {
  final client = HttpClient();
  final chunkSize = 250000;
  
  var currentStart = start;
  var currentEnd = end ?? totalSize - 1;
  
  while (currentStart <= currentEnd) {
    var chunkEnd = currentStart + chunkSize - 1;
    if (chunkEnd > currentEnd) {
      chunkEnd = currentEnd;
    }
    
    final req = await client.getUrl(Uri.parse(url));
    req.headers.set('Range', 'bytes=$currentStart-$chunkEnd');
    req.headers.set('User-Agent', 'Mozilla/5.0');
    final res = await req.close();
    
    print('Chunk HTTP \${res.statusCode} for \$currentStart-\$chunkEnd');
    
    if (res.statusCode != 206 && res.statusCode != 200) {
      throw Exception('HTTP \${res.statusCode}');
    }
    
    await for (final chunk in res) {
      yield chunk;
    }
    
    currentStart = chunkEnd + 1;
  }
}

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
  ];
  for (final id in list) {
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.android
      ]).timeout(Duration(seconds: 4));
      var info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
      var url = info.url.toString();
      
      var bytes = 0;
      await for (final chunk in chunkedStream(url, 0, 1000000, info.size.totalBytes)) {
        bytes += chunk.length;
      }
      print('$id STREAMED 1MB OK: $bytes bytes fetched with chunks');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

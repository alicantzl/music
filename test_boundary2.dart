import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
      var maxB = info.size.totalBytes - 1;
      
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('Range', 'bytes=0-$maxB');
      req.headers.set('User-Agent', 'Mozilla/5.0');
      final res = await req.close();
      final code = res.statusCode;
      print('$id FULL RANGE EXPLICIT HTTP: $code, CLEN: \${res.contentLength}');
      
      // try android user agent
      final req2 = await client.getUrl(Uri.parse(url));
      req2.headers.set('Range', 'bytes=1000-$maxB');
      req2.headers.set('User-Agent', 'com.google.android.youtube/17.36.4 (Linux; U; Android 12; GB) gzip');
      final res2 = await req2.close();
      print('$id 1000-MAX RANGE ANDROID UA HTTP: \${res2.statusCode}, CLEN: \${res2.contentLength}');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

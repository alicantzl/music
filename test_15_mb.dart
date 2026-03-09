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
      
      final client = HttpClient();
      var req = await client.getUrl(Uri.parse(url));
      req.headers.set('Range', 'bytes=0-1500000'); // 1.5MB
      req.headers.set('User-Agent', 'Mozilla/5.0');
      var res = await req.close();
      var code = res.statusCode;
      print('HTTP $code');
      await res.drain();

      req = await client.getUrl(Uri.parse(url));
      req.headers.set('Range', 'bytes=1500001-3000000'); // chunk 2
      req.headers.set('User-Agent', 'Mozilla/5.0');
      res = await req.close();
      code = res.statusCode;
      print('CHUNK 2 HTTP $code');

    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

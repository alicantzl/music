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
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('Range', 'bytes=0-100');
      req.headers.set('User-Agent', 'Mozilla/5.0');
      final res = await req.close();
      final code = res.statusCode;
      print('$id PLAY HTTP ANDROID WITH RANGE: $code');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

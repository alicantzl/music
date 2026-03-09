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
      final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
      final url = info.url.toString();
      
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('User-Agent', 'com.google.android.youtube/17.36.4 (Linux; U; Android 12; GB) gzip');
      final res = await req.close();
      final code = res.statusCode;
      print('$id Android URL WITH ANDROID HEADER HTTP: $code');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

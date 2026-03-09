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
        YoutubeApiClient.youtubeMusic
      ]).timeout(Duration(seconds: 4));
      final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
      final url = info.url.toString();
      
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      final code = (await req.close()).statusCode;
      print('$id YoutubeMusic URL Pure HTTP: $code');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

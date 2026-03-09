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
        YoutubeApiClient.safari
      ]).timeout(Duration(seconds: 4));
      final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
      final url = info.url.toString();
      
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      // Try fetching purely without User-Agent (like AVPlayer)
      final res = await req.close();
      print('$id Safari URL Pure HTTP (Like AVPlayer Default): \${res.statusCode}');
      
      final streamInfoStream = yt.videos.streamsClient.get(info);
      final first = await streamInfoStream.first;
      print('$id OK Safari NATIVE PIPE BYTES: \${first.length}');
    } catch (e) {
      print('$id FAILED safari: $e');
    }
  }
  exit(0);
}

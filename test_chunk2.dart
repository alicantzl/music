import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final id = 'fHI8X4OXluQ';
  try {
    final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
      YoutubeApiClient.android
    ]).timeout(Duration(seconds: 4));
    var info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
    var url = info.url.toString();
    
    final client = HttpClient();
    
    // Chunk 2 only
    var req = await client.getUrl(Uri.parse(url));
    req.headers.set('Range', 'bytes=250001-500000');
    req.headers.set('User-Agent', 'Mozilla/5.0');
    var res = await req.close();
    var code2 = res.statusCode;
    print('Chunk 2 (250001-500000) header: $code2');
    await res.drain();

  } catch (e) {}
  exit(0);
}

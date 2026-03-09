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
    
    // Chunk 1
    var client1 = HttpClient();
    var req1 = await client1.getUrl(Uri.parse(url));
    req1.headers.set('Range', 'bytes=0-250000');
    req1.headers.set('User-Agent', 'Mozilla/5.0');
    var res1 = await req1.close();
    var c1 = res1.statusCode;
    print('Chunk 1 header: $c1');
    await res1.drain();
    client1.close();

    // Chunk 2
    var client2 = HttpClient();
    var req2 = await client2.getUrl(Uri.parse(url));
    req2.headers.set('Range', 'bytes=250001-500000');
    req2.headers.set('User-Agent', 'Mozilla/5.0');
    var res2 = await req2.close();
    var c2 = res2.statusCode;
    print('Chunk 2 header: $c2');
    await res2.drain();
    client2.close();

  } catch (e) {}
  exit(0);
}

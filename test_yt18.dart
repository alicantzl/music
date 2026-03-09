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
    
    var req = await client.getUrl(Uri.parse(url));
    // NO RANGE!
    req.headers.set('User-Agent', 'com.google.android.youtube/17.36.4 (Linux; U; Android 12; GB) gzip');
    req.headers.set('Referer', 'https://www.youtube.com/');
    var res = await req.close();
    var code1 = res.statusCode;
    print('Pure URL with Android UA + Referer: $code1, CLEN: \${res.contentLength}');
    await res.drain();

  } catch (e) {}
  exit(0);
}

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
      var rawUrl = info.url;
      
      var qp = Map<String, String>.from(rawUrl.queryParameters);
      qp.remove('c');
      qp['c'] = 'TVHTML5';
      
      var url = rawUrl.replace(queryParameters: qp).toString();
      
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('User-Agent', 'Mozilla/5.0');
      req.headers.set('Range', 'bytes=1000000-2000000');
      var res = await req.close();
      var code = res.statusCode;
      print('URL with c=TVHTML5: HTTP $code, CLEN: \${res.contentLength}');

      qp.remove('c');
      qp['c'] = 'WEB';
      url = rawUrl.replace(queryParameters: qp).toString();
      final req2 = await client.getUrl(Uri.parse(url));
      req2.headers.set('User-Agent', 'Mozilla/5.0');
      req2.headers.set('Range', 'bytes=1000000-2000000');
      var res2 = await req2.close();
      print('URL with c=WEB: HTTP \${res2.statusCode}, CLEN: \${res2.contentLength}');

    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

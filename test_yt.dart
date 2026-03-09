import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest('dQw4w9WgXcQ');
  final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
  final url = info.url.toString();
  
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
  
  final res1 = await request.close();
  print('Result without Referer: \${res1.statusCode}');
  
  final request2 = await client.getUrl(Uri.parse(url));
  request2.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
  request2.headers.set('Referer', 'https://www.youtube.com/');
  final res2 = await request2.close();
  print('Result with Referer: \${res2.statusCode}');
  
  exit(0);
}

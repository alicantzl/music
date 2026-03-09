import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest('dQw4w9WgXcQ', ytClients: [
    YoutubeApiClient.ios,
    YoutubeApiClient.android,
    YoutubeApiClient.mweb,
    YoutubeApiClient.tv,
  ]);
  final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
  final url = info.url.toString();
  
  print('URL: $url');
  
  final client = HttpClient();
  var request = await client.getUrl(Uri.parse(url));
  request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
  var res1 = await request.close();
  print('Result ONE: ${res1.statusCode}');
  
  request = await client.getUrl(Uri.parse(url));
  request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
  request.headers.set('Referer', 'https://www.youtube.com/');
  res1 = await request.close();
  print('Result TWO (Referer): ${res1.statusCode}');
  
  request = await client.getUrl(Uri.parse(url));
  request.headers.set('Range', 'bytes=0-100');
  request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
  res1 = await request.close();
  print('Result RANGE: ${res1.statusCode}');

  final streamResult = yt.videos.streamsClient.get(info);
  final firstChunk = await streamResult.first;
  if (firstChunk != null) {
      print('yt stream get first bytes: success (${firstChunk.length})');
  }

  exit(0);
}

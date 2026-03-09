import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest('dQw4w9WgXcQ', ytClients: [
    YoutubeApiClient.ios,
  ]);
  final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
  final url = info.url.toString();
  
  final client = HttpClient();
  
  var request = await client.getUrl(Uri.parse(url));
  // NO CUSTOM HEADERS! This simulates iOS AVPlayer
  var res = await request.close();
  print('Result Pure: ${res.statusCode}');

  exit(0);
}

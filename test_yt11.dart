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
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED safari: $e');
    }
  }
  exit(0);
}

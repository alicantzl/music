import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
    'kJQP7kiw5Fk', // Despacito
  ];
  for (final id in list) {
    print('Testing $id...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.ios,
        YoutubeApiClient.android,
        YoutubeApiClient.mweb,
      ]);
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

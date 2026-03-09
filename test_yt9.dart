import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
  ];
  for (final id in list) {
    print('Testing iOS client explicitly for 20 seconds...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.ios
      ]).timeout(Duration(seconds: 20));
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

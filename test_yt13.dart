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
      
      print('Audio Only Streams:');
      for (final s in manifest.audioOnly) {
         print('- \${s.container.name} | \${s.bitrate} | \${s.url}');
      }
      print('Muxed Streams:');
      for (final s in manifest.muxed) {
         print('- \${s.container.name} | \${s.bitrate}');
      }
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

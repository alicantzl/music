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
      final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
      
      final streamInfoStream = yt.videos.streamsClient.get(info);
      var bytes = 0;
      await for (final chunk in streamInfoStream) {
        bytes += chunk.length;
        if (bytes > 1000000) break; // Read 1MB
      }
      print('$id OK NATIVE PIPE BYTES: $bytes');
      
    } catch (e) {
      print('$id FAILED: $e');
    }
  }
  exit(0);
}

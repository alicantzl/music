import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
  ];
  for (final id in list) {
    for (var clientType in [
      YoutubeApiClient.web,
      YoutubeApiClient.mweb,
      YoutubeApiClient.tv,
      YoutubeApiClient.safari,
      YoutubeApiClient.ios
    ]) {
      print('\\nTesting $clientType...');
      try {
        final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
          clientType
        ]).timeout(Duration(seconds: 4));
        print('Manifest OK for $clientType, \${manifest.audioOnly.length} streams');
      } catch (e) {
        print('FAILED client $clientType: $e');
      }
    }
  }
  exit(0);
}

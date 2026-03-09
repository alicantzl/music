import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
  ];
  for (final id in list) {
    print('Testing $id with android...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.android
      ]).timeout(Duration(seconds: 4));
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED Android: $e');
    }

    print('Testing $id with ios...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.ios
      ]).timeout(Duration(seconds: 4));
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED iOS: $e');
    }

    print('Testing $id with mweb...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.mweb
      ]).timeout(Duration(seconds: 4));
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED mweb: $e');
    }

    print('Testing $id with tv...');
    try {
      final manifest = await yt.videos.streamsClient.getManifest(id, ytClients: [
        YoutubeApiClient.tv
      ]).timeout(Duration(seconds: 4));
      print('$id OK: \${manifest.audioOnly.length} audio streams');
    } catch (e) {
      print('$id FAILED tv: $e');
    }
  }
  exit(0);
}

import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
  ];
  for (final id in list) {
    print('Testing $id with Safari client...');
    try {
      final hls = await yt.videos.streamsClient.getHttpLiveStreamUrl(VideoId(id));
      print('HLS MANIFEST ($id): $hls');
    } catch (e) {
      print('$id HLS FAILED: $e');
    }
  }
  exit(0);
}

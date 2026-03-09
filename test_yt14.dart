import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  
  // Search for the song using YT Music
  final searchResults = await yt.search.search('Blinding Lights', filter: TypeFilters.video);
  final target = searchResults.first;
  final id = target.id.value;
  print('Found YT Search Video: \${target.title} ($id)');
  
  try {
    final manifest = await yt.videos.streamsClient.getManifest(id).timeout(Duration(seconds: 4));
    final info = manifest.audioOnly.where((s) => s.container.name.toLowerCase() == 'mp4').first;
    
    final client = HttpClient();
    final req = await client.getUrl(Uri.parse(info.url.toString()));
    final res = await req.close();
    final code = res.statusCode;
    print('$id PLAY HTTP DEFAULT: $code');
  } catch (e) {
    print('$id FAILED: $e');
  }
  exit(0);
}

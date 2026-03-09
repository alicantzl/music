import 'dart:io';
import 'dart:convert';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final id = 'fHI8X4OXluQ';
  
  try {
    // 1. Get YouTube Video Metadata
    final video = await yt.videos.get(VideoId(id));
    final title = video.title;
    final author = video.author;
    print('Youtube: $title by $author');
    
    // 2. Search JioSaavn API
    final query = Uri.encodeComponent('$title $author');
    final client = HttpClient();
    final apiUrl = 'https://jiosaavn-api-privatecvc2.vercel.app';
    
    final sreq = await client.getUrl(Uri.parse('$apiUrl/search/songs?query=$query'));
    sreq.headers.add('User-Agent', 'Mozilla/5.0');
    final sres = await sreq.close();
    
    if (sres.statusCode == 200) {
      final body = await sres.transform(utf8.decoder).join();
      final data = json.decode(body);
      final results = data['data']['results'] as List;
      
      if (results.isNotEmpty) {
        final saavnId = results.first['id'];
        var sName = results.first['name'];
        print('Saavn MATCH: $sName (ID: $saavnId)');
        
        // 3. Get Stream
        final dreq = await client.getUrl(Uri.parse('$apiUrl/songs?id=$saavnId'));
        dreq.headers.add('User-Agent', 'Mozilla/5.0');
        final dres = await dreq.close();
        
        if (dres.statusCode == 200) {
           final dbody = await dres.transform(utf8.decoder).join();
           final ddata = json.decode(dbody);
           final list = ddata['data'] as List;
           final dlist = list.first['downloadUrl'] as List;
           final url = dlist.last['link'];
           
           print('URL GRABBED: $url');
           
           // Test play
           final preq = await client.getUrl(Uri.parse(url));
           final pres = await preq.close();
           print('STREAM HTTP: \${pres.statusCode}');
        }
      } else {
        print('NO SAAVN MATCH!');
      }
    }
  } catch(e) {
    print('FAIL API: $e');
  }
  exit(0);
}

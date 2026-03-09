import 'dart:io';
import 'dart:convert';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String cleanString(String text) {
  var cleaned = text.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), '');
  cleaned = cleaned.replaceAll(RegExp(r'(official|audio|video|music|lyric|lyrics|hq|hd|4k|8k|remix|edit|-)', caseSensitive: false), '');
  cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ');
  return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
}

void main() async {
  final yt = YoutubeExplode();
  final list = [
    'fHI8X4OXluQ', // Blinding Lights
    'kJQP7kiw5Fk', // Despacito
    'JGwWNGJdvx8', // Shape of You
  ];
  
  for (final id in list) {
    try {
      final video = await yt.videos.get(VideoId(id));
      final title = cleanString(video.title);
      print('Cleaned Search: "$title"');
      
      final query = Uri.encodeComponent(title);
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
          // get stream
          final dreq = await client.getUrl(Uri.parse('$apiUrl/songs?id=$saavnId'));
          final dres = await dreq.close();
          final dbody = await dres.transform(utf8.decoder).join();
          final ddata = json.decode(dbody);
          final list = ddata['data'] as List;
          final dlist = list.first['downloadUrl'] as List;
          final url = dlist.last['link'];
           
          print('✅ Saavn MATCH: $sName -> $url\n');
        } else {
          print('❌ NO SAAVN MATCH FOR "$title"\n');
        }
      }
    } catch(e) {
      print('FAIL API: $e\n');
    }
  }
  exit(0);
}

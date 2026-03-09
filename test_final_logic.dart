import 'dart:convert';
import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String _cleanString(String text) {
  var cleaned = text.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), '');
  cleaned = cleaned.replaceAll(RegExp(r'(official|audio|video|music|lyric|lyrics|hq|hd|4k|8k|remix|edit|-)', caseSensitive: false), '');
  cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ');
  return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
}

void main() async {
  final yt = YoutubeExplode();
  final videoId = 'fHI8X4OXluQ'; // Blinding Lights
  
  print('--- TEST: StreamResolver Logic ---');
  try {
    print('1. YouTube Metadata Alınıyor...');
    final video = await yt.videos.get(VideoId(videoId));
    final title = _cleanString(video.title);
    final author = _cleanString(video.author.replaceAll(RegExp(r'VEVO', caseSensitive: false), ''));
    final query = Uri.encodeComponent('$title $author');
    print('   Temizlenmiş Arama: $title $author');

    final client = HttpClient();
    final mirrors = [
      'https://jiosaavn-api-privatecvc2.vercel.app',
      'https://music-api.up.railway.app',
    ];

    bool found = false;
    for (var mirror in mirrors) {
      print('2. Mirror Deneniyor: $mirror');
      try {
        final sreq = await client.getUrl(Uri.parse('$mirror/search/songs?query=$query'));
        sreq.headers.add('User-Agent', 'Mozilla/5.0');
        final sres = await sreq.close().timeout(Duration(seconds: 5));
        
        if (sres.statusCode == 200) {
          final body = await sres.transform(utf8.decoder).join();
          final data = json.decode(body);
          final results = data['data']['results'] as List;
          
          if (results.isNotEmpty) {
            final saavnId = results.first['id'];
            final name = results.first['name'];
            print('   MAÇ BULUNDU: $name (ID: $saavnId)');
            
            final dreq = await client.getUrl(Uri.parse('$mirror/songs?id=$saavnId'));
            final dres = await dreq.close();
            
            if (dres.statusCode == 200) {
              final dbody = await dres.transform(utf8.decoder).join();
              final ddata = json.decode(dbody);
              final durl = ddata['data'][0]['downloadUrl'].last['link'];
              print('3. Akış URL Alındı: $durl');
              
              print('4. Akış Test Ediliyor (Range Request)...');
              final testReq = await client.getUrl(Uri.parse(durl));
              testReq.headers.add('Range', 'bytes=0-1000000');
              testReq.headers.add('User-Agent', 'Mozilla/5.0');
              final testRes = await testReq.close();
              
              print('   SONUÇ: HTTP ${testRes.statusCode}');
              if (testRes.statusCode == 206 || testRes.statusCode == 200) {
                print('✅ BAŞARILI: Çözüm şu an aktif ve çalışıyor!');
                found = true;
                break;
              }
            }
          }
        }
      } catch (e) {
        print('   Hata: $e');
      }
    }
    
    if (!found) {
      print('❌ BAŞARISIZ: Hiçbir mirror çalışmadı veya sonuç bulunamadı.');
    }

  } catch (e) {
    print('Global Hata: $e');
  }
  exit(0);
}

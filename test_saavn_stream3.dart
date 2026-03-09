import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  final apiUrl = 'https://jiosaavn-api-privatecvc2.vercel.app';
  
  try {
    final creq = await client.getUrl(Uri.parse('$apiUrl/songs?id=pizXlfUB'))
      ..headers.add('User-Agent', 'Mozilla/5.0');
    final cres = await creq.close().timeout(Duration(seconds: 4));
    var code = cres.statusCode;
    if (code == 200) {
      final body = await cres.transform(utf8.decoder).join();
      final data = json.decode(body);
      final list = data['data'] as List;
      final url = list.first['downloadUrl'].last['url'];
      print('Stream URL: $url');
      
      // Test the URL works?
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('Range', 'bytes=0-1500000'); // 1.5MB chunk
      final res = await req.close();
      print('STREAM HTTP: \${res.statusCode}');
      
      // Test full stream
      final req2 = await client.getUrl(Uri.parse(url));
      final res2 = await req2.close();
      print('FULL STREAM HTTP: \${res2.statusCode}, CLEN: \${res2.contentLength}');
    }
  } catch(e) {
    print('FAIL API: $e');
  }
  exit(0);
}

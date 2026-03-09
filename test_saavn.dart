import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  try {
    final req = await client.getUrl(Uri.parse('https://saavn.me/search/songs?query=blinding%20lights'));
    final res = await req.close();
    var cd = res.statusCode;
    print('JioSaavn HTTP: $cd');
    
    if (cd == 200) {
      final body = await res.transform(utf8.decoder).join();
      final data = json.decode(body);
      final results = data['data']['results'] as List;
      if (results.isNotEmpty) {
        final first = results.first;
        final durl = first['downloadUrl'];
        print('Download URLs: $durl');
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  exit(0);
}

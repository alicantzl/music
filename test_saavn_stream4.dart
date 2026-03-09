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
      print(json.encode(data));
    }
  } catch(e) {
    print('FAIL API: $e');
  }
  exit(0);
}

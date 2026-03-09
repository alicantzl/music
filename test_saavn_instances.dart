import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  final endpoints = [
    'https://jiosaavn-api-privatecvc2.vercel.app',
    'https://saavn.dev',
    'https://jiosaavn-api-v3.vercel.app',
    'https://music-api.up.railway.app'
  ];
  
  for (var apiUrl in endpoints) {
    print('Testing $apiUrl...');
    try {
      final creq = await client.getUrl(Uri.parse('$apiUrl/api/search/songs?query=blinding%20lights'))
        ..headers.add('User-Agent', 'Mozilla/5.0');
      final cres = await creq.close().timeout(Duration(seconds: 4));
      print('SUCCESS $apiUrl: \${cres.statusCode}');
    } catch(e) {
      print('FAIL $apiUrl: $e');
    }
  }
  exit(0);
}

import 'dart:io';

void main() async {
  final client = HttpClient();
  
  final endpoints = [
    'https://pipedapi.kavin.rocks',
    'https://pipedapi.smnz.de',
    'https://api.piped.privacydev.net',
    'https://pipedapi.moomoo.me',
    'https://pipedapi.auth.us.eu.org'
  ];
  
  for (var apiUrl in endpoints) {
    try {
      final creq = await client.getUrl(Uri.parse('$apiUrl/streams/fHI8X4OXluQ'))
        ..headers.add('User-Agent', 'Mozilla/5.0');
      final cres = await creq.close().timeout(Duration(seconds: 4));
      final code = cres.statusCode;
      print('SUCCESS $apiUrl: $code');
    } catch(e) {
      print('FAIL $apiUrl: \$e');
    }
  }
  exit(0);
}

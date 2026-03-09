import 'dart:io';

void main() async {
  final client = HttpClient();
  
  final endpoints = [
    'https://vid.puffyan.us',
    'https://inv.tux.pizza',
    'https://invidious.projectsegfau.lt',
    'https://yewtu.be'
  ];
  
  for (var apiUrl in endpoints) {
    try {
      final creq = await client.getUrl(Uri.parse('$apiUrl/api/v1/videos/fHI8X4OXluQ'))
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

import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  final req = await client.postUrl(Uri.parse('https://api.cobalt.tools/'));
  req.headers.set('Accept', 'application/json');
  req.headers.set('Content-Type', 'application/json');
  req.add(utf8.encode(json.encode({
    'url': 'https://www.youtube.com/watch?v=fHI8X4OXluQ',
    'isAudioOnly': true,
    'aFormat': 'best'
  })));
  
  final res = await req.close();
  print('Cobalt HTTP \${res.statusCode}');
  final body = await res.transform(utf8.decoder).join();
  print('Cobalt response: $body');
  exit(0);
}

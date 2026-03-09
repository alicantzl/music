import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  final req = await client.postUrl(Uri.parse('https://co.wuk.sh/api/json'));
  req.headers.set('Accept', 'application/json');
  req.headers.set('Content-Type', 'application/json');
  req.add(utf8.encode(json.encode({
    'url': 'https://www.youtube.com/watch?v=fHI8X4OXluQ',
    'vCodec': 'none',
    'aFormat': 'mp3'
  })));
  
  try {
    final res = await req.close();
    print('COHTTP \${res.statusCode}');
    final body = await res.transform(utf8.decoder).join();
    print('Body: $body');
  } catch (e) {
    print('Failed: $e');
  }
  exit(0);
}

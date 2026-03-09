import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  final req = await client.getUrl(Uri.parse('https://instances.hyper.lol/instances.json'));
  final res = await req.close();
  final body = await res.transform(utf8.decoder).join();
  final List data = json.decode(body);
  
  final working = data.where((i) => i['api_online'] == true && i['cors'] == 1).toList();
  print('Found \${working.length} cobalt instances');
  
  for (var i = 0; i < 5 && i < working.length; i++) {
    final domain = working[i]['domain'];
    final apiUrl = 'https://$domain';
    print('Testing $apiUrl...');
    try {
      final creq = await client.postUrl(Uri.parse('$apiUrl/'));
      creq.headers.set('Accept', 'application/json');
      creq.headers.set('Content-Type', 'application/json');
      creq.headers.set('User-Agent', 'Mozilla/5.0');
      creq.add(utf8.encode(json.encode({
        'url': 'https://www.youtube.com/watch?v=fHI8X4OXluQ',
        'isAudioOnly': true,
        'aFormat': 'mp3'
      })));
      final cres = await creq.close().timeout(Duration(seconds: 5));
      final cbody = await cres.transform(utf8.decoder).join();
      print('HTTP \${cres.statusCode} -> $cbody');
    } catch(e) {
      print('Fail: $e');
    }
  }
  exit(0);
}

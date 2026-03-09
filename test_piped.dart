import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  client.connectionTimeout = Duration(seconds: 3);
  final req = await client.getUrl(Uri.parse('https://raw.githubusercontent.com/TeamPiped/Piped/main/instances.json'));
  final res = await req.close();
  final body = await res.transform(utf8.decoder).join();
  final data = json.decode(body) as List;
  
  final validInstances = data.where((i) => i['up_to_date'] == true && i['locations'] != '').toList();
  
  print('Found \${validInstances.length} up-to-date instances.');
  
  for (var i = 0; i < 5 && i < validInstances.length; i++) {
    final apiUrl = validInstances[i]['api_url'];
    print('Testing $apiUrl...');
    final sw = Stopwatch()..start();
    try {
      final creq = await client.getUrl(Uri.parse('$apiUrl/streams/fHI8X4OXluQ'))
        ..headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');
      final cres = await creq.close().timeout(Duration(seconds: 5));
      if (cres.statusCode == 200) {
        print('SUCCESS $apiUrl in \${sw.elapsedMilliseconds}ms');
      } else {
        print('FAIL $apiUrl HTTP \${cres.statusCode}');
      }
    } catch(e) {
      print('FAIL $apiUrl: e');
    }
  }
  exit(0);
}

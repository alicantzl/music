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
  
  for (var i = 0; i < validInstances.length; i++) {
    final apiUrl = validInstances[i]['api_url'];
    try {
      final creq = await client.getUrl(Uri.parse('$apiUrl/streams/fHI8X4OXluQ'))
        ..headers.add('User-Agent', 'Mozilla/5.0');
      final cres = await creq.close().timeout(Duration(seconds: 3));
      var code = cres.statusCode;
      if (code == 200) {
        print('WORKING PIPED API: $apiUrl');
        exit(0);
      }
    } catch(e) {}
  }
  print('NO WORKING PIPED API FOUND');
  exit(1);
}

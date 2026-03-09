import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  final req = await client.getUrl(Uri.parse('https://invidious.jing.rocks/api/v1/videos/fHI8X4OXluQ'));
  final res = await req.close();
  print('Invidious HTTP \${res.statusCode}');
  
  if (res.statusCode == 200) {
    final body = await res.transform(utf8.decoder).join();
    final data = json.decode(body);
    final formats = data['adaptiveFormats'] as List;
    final m4a = formats.where((f) => f['type'].toString().contains('mp4') && f['type'].toString().contains('audio')).toList();
    if (m4a.isNotEmpty) {
      final streamUrl = m4a.first['url'];
      print('FOUND M4A: $streamUrl');
      
      final req2 = await client.getUrl(Uri.parse(streamUrl));
      final res2 = await req2.close();
      print('M4A Stream HTTP \${res2.statusCode}');
    }
  }
  exit(0);
}

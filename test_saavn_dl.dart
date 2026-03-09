import 'dart:io';

void main() async {
  final url = 'https://aac.saavncdn.com/820/5ddb9a79a5218f85ca9bef170f3a461d_320.mp4';
  final client = HttpClient();
  
  try {
    print('Testing download from Saavn CDN: $url');
    final req = await client.getUrl(Uri.parse(url));
    req.headers.set('User-Agent', 'Mozilla/5.0');
    final res = await req.close();
    
    final code = res.statusCode;
    print('HTTP: $code');
    if (res.statusCode == 200) {
      final file = File('test_saavn_download.mp4');
      final sink = file.openWrite();
      await res.pipe(sink);
      await sink.close();
      final size = await file.length();
      print('Downloaded size: $size bytes');
      await file.delete();
    }
  } catch(e) {
    print('Error: $e');
  }
  exit(0);
}

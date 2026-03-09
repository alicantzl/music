import 'dart:io';

class LocalProxyServer {
  static HttpServer? _server;
  static int? get port => _server?.port;
  static final Map<String, String> _urlMap = {};

  static Future<void> startServer() async {
    if (_server != null) return;
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _server!.listen(_handleRequest);
    } catch (e) {
      print('Proxy Server Error: $e');
    }
  }

  static String addUrl(String id, String targetUrl) {
    _urlMap[id] = targetUrl;
    return 'http://127.0.0.1:${_server!.port}/$id';
  }

  static Future<void> _handleRequest(HttpRequest request) async {
    final path = request.uri.path.substring(1); 
    final targetUrl = _urlMap[path];
    
    if (targetUrl == null) {
      request.response.statusCode = 404;
      await request.response.close();
      return;
    }

    try {
      final client = HttpClient();
      final ytRequest = await client.getUrl(Uri.parse(targetUrl));
      
      // We spoof user agent and referer to bypass YouTube 403 limits
      ytRequest.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
      ytRequest.headers.set('Referer', 'https://www.youtube.com/');
      
      // Forward the range request from AVPlayer exactly
      final range = request.headers.value('range');
      if (range != null) {
        ytRequest.headers.set('Range', range);
      }

      final ytResponse = await ytRequest.close();
      
      request.response.statusCode = ytResponse.statusCode;
      
      // Copy essential headers back to AVPlayer
      ytResponse.headers.forEach((name, values) {
        for (final value in values) {
          if (name.toLowerCase() != 'transfer-encoding') {
            request.response.headers.add(name, value);
          }
        }
      });

      await ytResponse.pipe(request.response);
      client.close(); // Clean up client resources
    } catch (e) {
      if (request.response.connectionInfo != null) {
        request.response.statusCode = 500;
        await request.response.close();
      }
    }
  }
}

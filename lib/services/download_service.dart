import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';
import 'stream_resolver.dart';

class DownloadService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<String> downloadSong(SongModel song) async {
    try {
      // Check if already downloaded
      final box = Hive.box('downloads');
      if (box.containsKey(song.id)) {
        final existing = Map<String, dynamic>.from(box.get(song.id) as Map);
        final path = existing['localPath'] as String?;
        if (path != null && await File(path).exists()) {
          debugPrint('Already downloaded: $path');
          return 'Already downloaded';
        }
      }

      debugPrint('Starting download for: ${song.title}');

      final resolved = await StreamResolver.resolve(
        song.id,
        title: song.title,
        artist: song.artist,
      );
      if (resolved == null) {
        return 'Error: No audio stream available (ciphers/APIs blocked)';
      }

      // Save to permanent app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/download');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      const ext = 'm4a';
      final cleanTitle = song.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '').replaceAll(' ', '_');
      final fileName = '${cleanTitle}_${song.id}.$ext';
      final file = File('${folder.path}/$fileName');
      final sink = file.openWrite();

      if (resolved.info != null) {
        // Native youtube_explode_dart pipe completely bypasses 403 and automatically handles chunks
        final stream = _yt.videos.streamsClient.get(resolved.info!);
        await stream.pipe(sink);
      } else if (resolved.url != null) {
        // Fallback to manually getting the URL
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse(resolved.url!));
        request.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');
        request.headers.add('Referer', 'https://www.youtube.com/');
        final response = await request.close();
        if (response.statusCode != 200) {
          return 'Error: HTTP ${response.statusCode} during download';
        }
        await response.pipe(sink);
      }

      await sink.flush();
      await sink.close();

      final fileSize = await file.length();
      debugPrint('Downloaded: ${song.title} (${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB)');

      // Create updated song model with local path (only filename to avoid iOS Sandbox issues)
      final downloadedSong = song.copyWith(localPath: fileName);

      // Save to Hive for persistence
      await box.put(song.id, downloadedSong.toMap());

      return fileName;
    } catch (e) {
      debugPrint('Download error: $e');
      return 'Error: $e';
    }
  }

  /// Check if a song is already downloaded and return its absolute local path dynamically
  static Future<String?> getLocalPath(String songId) async {
    final box = Hive.box('downloads');
    if (box.containsKey(songId)) {
      final data = Map<String, dynamic>.from(box.get(songId) as Map);
      final pathOrName = data['localPath'] as String?;
      
      if (pathOrName != null) {
        // If it's already an absolute path (legacy downloads before update)
        if (pathOrName.contains('/')) {
           final fileName = pathOrName.split('/').last;
           final dir = await getApplicationDocumentsDirectory();
           return '${dir.path}/download/$fileName';
        }
        
        // Return constructed dynamically
        final dir = await getApplicationDocumentsDirectory();
        return '${dir.path}/download/$pathOrName';
      }
    }
    return null;
  }
}

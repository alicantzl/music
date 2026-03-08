import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';

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

      final manifest = await _yt.videos.streamsClient.getManifest(song.id);
      
      // Use MP4 audio only (iOS compatible, smaller file size)
      final mp4Streams = manifest.audioOnly
          .where((s) => s.container.name.toLowerCase() == 'mp4')
          .toList();

      StreamInfo audioStream;
      if (mp4Streams.isNotEmpty) {
        mp4Streams.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        audioStream = mp4Streams.first;
      } else if (manifest.audioOnly.isNotEmpty) {
        audioStream = manifest.audioOnly.withHighestBitrate();
      } else {
        return 'Error: No audio stream available';
      }

      // Save to permanent app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/music_downloads');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final ext = audioStream.container.name.toLowerCase() == 'mp4' ? 'm4a' : 'webm';
      final file = File('${folder.path}/${song.id}.$ext');

      // Download the stream
      final stream = _yt.videos.streamsClient.get(audioStream);
      final sink = file.openWrite();
      await stream.pipe(sink);
      await sink.flush();
      await sink.close();

      final fileSize = await file.length();
      debugPrint('Downloaded: ${song.title} (${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB)');

      // Create updated song model with local path
      final downloadedSong = song.copyWith(localPath: file.path);

      // Save to Hive for persistence
      await box.put(song.id, downloadedSong.toMap());

      return file.path;
    } catch (e) {
      debugPrint('Download error: $e');
      return 'Error: $e';
    }
  }

  /// Check if a song is already downloaded and return its local path
  static String? getLocalPath(String songId) {
    final box = Hive.box('downloads');
    if (box.containsKey(songId)) {
      final data = Map<String, dynamic>.from(box.get(songId) as Map);
      return data['localPath'] as String?;
    }
    return null;
  }
}

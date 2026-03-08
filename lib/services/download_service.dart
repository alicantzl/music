import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';

class DownloadService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<SongModel?> downloadSong(SongModel song) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(song.id);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      
      final dir = await getApplicationDocumentsDirectory();
      // iOS documents directory is completely safe and persistent natively
      final folder = Directory('${dir.path}/downloads');
      if (!await folder.exists()) await folder.create(recursive: true);
      
      final file = File('${folder.path}/${song.id}.m4a');
      
      if (!await file.exists()) {
        final stream = _yt.videos.streamsClient.get(audioStream);
        final sink = file.openWrite();
        await stream.pipe(sink);
        await sink.flush();
        await sink.close();
      }

      final downloadedSong = song.copyWith(localPath: file.path);
      
      // Update DB
      final box = Hive.box('downloads');
      await box.put(song.id, downloadedSong.toMap());
      
      return downloadedSong;
    } catch (e) {
      return null;
    }
  }
}

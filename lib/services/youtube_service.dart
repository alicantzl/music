import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/song_model.dart';

class YoutubeService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<SongModel>> searchSongs(String query) async {
    try {
      final searchResults = await _yt.search.search(query);
      return searchResults.whereType<Video>().map(_videoToSong).toList();
    } catch (e) {
      return [];
    }
  }

  Future<SongModel?> getSongDetails(String videoId) async {
    try {
      final video = await _yt.videos.get(videoId);
      return _videoToSong(video);
    } catch (e) {
      return null;
    }
  }

  Future<List<SongModel>> getTrending() async {
    return searchSongs('latest hits music video');
  }

  SongModel _videoToSong(Video video) {
    return SongModel(
      id: video.id.value,
      title: _cleanTitle(video.title),
      artist: video.author,
      albumArt: video.thumbnails.highResUrl,
      durationSeconds: video.duration?.inSeconds ?? 0,
    );
  }

  String _cleanTitle(String title) {
    return title
        .replaceAll(RegExp(r'\(official.*\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\[official.*\]', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(lyric.*\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'music video', caseSensitive: false), '')
        .trim();
  }

  void dispose() {
    _yt.close();
  }
}

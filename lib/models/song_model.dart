import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String artist;
  
  @HiveField(3)
  final String albumArt;
  
  @HiveField(4)
  final int durationSeconds;
  
  @HiveField(5)
  final String? localPath;
  
  @HiveField(6)
  final String? album;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.durationSeconds,
    this.localPath,
    this.album,
  });

  Duration get duration => Duration(seconds: durationSeconds);
  bool get isDownloaded => localPath != null;

  SongModel copyWith({
    String? localPath,
  }) {
    return SongModel(
      id: id,
      title: title,
      artist: artist,
      albumArt: albumArt,
      durationSeconds: durationSeconds,
      localPath: localPath ?? this.localPath,
      album: album,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumArt': albumArt,
      'durationSeconds': durationSeconds,
      'localPath': localPath,
      'album': album,
    };
  }
}

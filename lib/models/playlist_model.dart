import 'package:hive/hive.dart';
import 'song_model.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final List<SongModel> songs;
  
  @HiveField(3)
  final DateTime createdAt;
  
  @HiveField(4)
  final String? imagePath;
  
  PlaylistModel({
    required this.id,
    required this.name,
    required this.songs,
    required this.createdAt,
    this.imagePath,
  });

  PlaylistModel copyWith({
    String? name,
    List<SongModel>? songs,
    String? imagePath,
  }) {
    return PlaylistModel(
      id: id,
      name: name ?? this.name,
      songs: songs ?? this.songs,
      createdAt: createdAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

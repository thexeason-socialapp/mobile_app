import '../../domain/entities/thread.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/post.dart';
import 'media_model.dart';

/// Data model for Thread with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class ThreadModel extends Thread {
  const ThreadModel({
    required super.id,
    required super.userId,
    required super.content,
    super.media,
    super.replies,
    super.likes,
    super.likedBy,
    required super.createdAt,
    super.visibility,
    super.parentThreadId,
  });

  factory ThreadModel.fromEntity(Thread entity) {
    return ThreadModel(
      id: entity.id,
      userId: entity.userId,
      content: entity.content,
      media: entity.media,
      replies: entity.replies,
      likes: entity.likes,
      likedBy: entity.likedBy,
      createdAt: entity.createdAt,
      visibility: entity.visibility,
      parentThreadId: entity.parentThreadId,
    );
  }

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      media: json['media'] != null
          ? MediaModel.fromJson(json['media'] as Map<String, dynamic>)
          : null,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      likes: json['likes'] as int? ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      visibility: _parseVisibility(json['visibility'] as String?),
      parentThreadId: json['parentThreadId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      if (media != null) 'media': MediaModel.fromEntity(media!).toJson(),
      'replies': replies,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'visibility': visibility.name,
      if (parentThreadId != null) 'parentThreadId': parentThreadId,
    };
  }

  Thread toEntity() {
    return Thread(
      id: id,
      userId: userId,
      content: content,
      media: media,
      replies: replies,
      likes: likes,
      likedBy: likedBy,
      createdAt: createdAt,
      visibility: visibility,
      parentThreadId: parentThreadId,
    );
  }

  static PostVisibility _parseVisibility(String? visibility) {
    if (visibility == null) return PostVisibility.public;
    
    switch (visibility.toLowerCase()) {
      case 'public':
        return PostVisibility.public;
      case 'followers':
        return PostVisibility.followers;
      case 'private':
        return PostVisibility.private;
      default:
        return PostVisibility.public;
    }
  }
}
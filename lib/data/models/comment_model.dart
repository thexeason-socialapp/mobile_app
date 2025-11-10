import '../../domain/entities/comment.dart';
import '../../domain/entities/media.dart';
import 'media_model.dart';

/// Data model for Comment with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    super.parentCommentId,
    required super.content,
    super.media,
    super.likes,
    super.likedBy,
    super.replies,
    required super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.mentions,
  });

  factory CommentModel.fromEntity(Comment entity) {
    return CommentModel(
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      parentCommentId: entity.parentCommentId,
      content: entity.content,
      media: entity.media,
      likes: entity.likes,
      likedBy: entity.likedBy,
      replies: entity.replies,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      mentions: entity.mentions,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      content: json['content'] as String,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? const [],
      likes: json['likes'] as int? ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      if (parentCommentId != null) 'parentCommentId': parentCommentId,
      'content': content,
      'media': media.map((m) => MediaModel.fromEntity(m).toJson()).toList(),
      'likes': likes,
      'likedBy': likedBy,
      'replies': replies,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'mentions': mentions,
    };
  }

  Comment toEntity() {
    return Comment(
      id: id,
      postId: postId,
      userId: userId,
      parentCommentId: parentCommentId,
      content: content,
      media: media,
      likes: likes,
      likedBy: likedBy,
      replies: replies,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      mentions: mentions,
    );
  }
}
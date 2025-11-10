import '../../domain/entities/post.dart';
import '../../domain/entities/media.dart';
import 'media_model.dart';

/// Data model for PostMetadata with JSON serialization
class PostMetadataModel extends PostMetadata {
  const PostMetadataModel({
    super.views,
    super.impressions,
    super.engagementRate,
  });

  factory PostMetadataModel.fromEntity(PostMetadata entity) {
    return PostMetadataModel(
      views: entity.views,
      impressions: entity.impressions,
      engagementRate: entity.engagementRate,
    );
  }

  factory PostMetadataModel.fromJson(Map<String, dynamic> json) {
    return PostMetadataModel(
      views: json['views'] as int? ?? 0,
      impressions: json['impressions'] as int? ?? 0,
      engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'views': views,
      'impressions': impressions,
      'engagementRate': engagementRate,
    };
  }

  PostMetadata toEntity() {
    return PostMetadata(
      views: views,
      impressions: impressions,
      engagementRate: engagementRate,
    );
  }
}

/// Data model for Post with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.content,
    super.media,
    super.likes,
    super.commentsCount,
    super.sharesCount,
    super.likedBy,
    super.hashtags,
    super.mentions,
    super.isPublic,
    required super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.visibility,
    super.metadata,
  });

  /// Create PostModel from domain entity
  factory PostModel.fromEntity(Post entity) {
    return PostModel(
      id: entity.id,
      userId: entity.userId,
      content: entity.content,
      media: entity.media,
      likes: entity.likes,
      commentsCount: entity.commentsCount,
      sharesCount: entity.sharesCount,
      likedBy: entity.likedBy,
      hashtags: entity.hashtags,
      mentions: entity.mentions,
      isPublic: entity.isPublic,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      visibility: entity.visibility,
      metadata: entity.metadata,
    );
  }

  /// Create PostModel from Firestore JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? const [],
      likes: json['likes'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      sharesCount: json['sharesCount'] as int? ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      isPublic: json['isPublic'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      visibility: _parseVisibility(json['visibility'] as String?),
      metadata: json['metadata'] != null
          ? PostMetadataModel.fromJson(json['metadata'] as Map<String, dynamic>)
          : const PostMetadata(),
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'media': media.map((m) => MediaModel.fromEntity(m).toJson()).toList(),
      'likes': likes,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'likedBy': likedBy,
      'hashtags': hashtags,
      'mentions': mentions,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'visibility': visibility.name,
      'metadata': PostMetadataModel.fromEntity(metadata).toJson(),
    };
  }

  /// Convert to domain entity
  Post toEntity() {
    return Post(
      id: id,
      userId: userId,
      content: content,
      media: media,
      likes: likes,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      likedBy: likedBy,
      hashtags: hashtags,
      mentions: mentions,
      isPublic: isPublic,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      visibility: visibility,
      metadata: metadata,
    );
  }

  /// Helper to parse PostVisibility from string
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
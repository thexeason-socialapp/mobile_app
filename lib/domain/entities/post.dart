/// 📝 POST ENTITY
/// Pure Dart class representing a post in Thexeason
/// Supports text, images, videos, and voice notes
/// No dependencies on external packages

import 'media.dart';

enum PostVisibility {
  public,
  followers,
  private, followersOnly,
}

class Post {
  final String id;
  final String userId;
  final String content;
  final List<Media> media;
  final int likes;
  final int commentsCount;
  final int sharesCount;
  final List<String> likedBy;
  final List<String> hashtags;
  final List<String> mentions;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final PostVisibility visibility;
  final PostMetadata metadata;

  const Post({
    required this.id,
    required this.userId,
    required this.content,
    this.media = const [],
    this.likes = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likedBy = const [],
    this.hashtags = const [],
    this.mentions = const [],
    this.isPublic = true,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.visibility = PostVisibility.public,
    this.metadata = const PostMetadata(),
  });

  /// Check if this post is liked by a specific user
  bool isLikedBy(String userId) {
    return likedBy.contains(userId);
  }

  /// Check if post is deleted
  bool get isDeleted => deletedAt != null;

  /// Create a copy of this post with updated fields
  Post copyWith({
    String? id,
    String? userId,
    String? content,
    List<Media>? media,
    int? likes,
    int? commentsCount,
    int? sharesCount,
    List<String>? likedBy,
    List<String>? hashtags,
    List<String>? mentions,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    PostVisibility? visibility,
    PostMetadata? metadata,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      media: media ?? this.media,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      likedBy: likedBy ?? this.likedBy,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      visibility: visibility ?? this.visibility,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, likes: $likes, comments: $commentsCount)';
  }
}

/// Post metadata for analytics
class PostMetadata {
  final int views;
  final int impressions;
  final double engagementRate;

  const PostMetadata({
    this.views = 0,
    this.impressions = 0,
    this.engagementRate = 0.0,
  });

  PostMetadata copyWith({
    int? views,
    int? impressions,
    double? engagementRate,
  }) {
    return PostMetadata(
      views: views ?? this.views,
      impressions: impressions ?? this.impressions,
      engagementRate: engagementRate ?? this.engagementRate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostMetadata &&
        other.views == views &&
        other.impressions == impressions &&
        other.engagementRate == engagementRate;
  }

  @override
  int get hashCode => views.hashCode ^ impressions.hashCode ^ engagementRate.hashCode;

  @override
  String toString() {
    return 'PostMetadata(views: $views, impressions: $impressions, engagement: $engagementRate)';
  }
}
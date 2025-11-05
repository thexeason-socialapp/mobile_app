// import 'package:thexeasonapp/domain/entities/post.dart';

import 'package:thexeasonapp/domain/entities/media.dart';

/// 💬 COMMENT ENTITY
/// Pure Dart class representing a comment on a post
/// Supports nested replies (threaded comments)
/// No dependencies on external packages

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String? parentCommentId; // null for top-level comments
  final String content;
  final List<Media> media; // Optional images/videos in comments
  final int likes;
  final List<String> likedBy;
  final List<String> replies; // IDs of child comments
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<String> mentions;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentCommentId,
    required this.content,
    this.media = const [],
    this.likes = 0,
    this.likedBy = const [],
    this.replies = const [],
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.mentions = const [],
  });

  /// Check if this is a top-level comment (not a reply)
  bool get isTopLevel => parentCommentId == null;

  /// Check if this comment has replies
  bool get hasReplies => replies.isNotEmpty;

  /// Check if this comment is liked by a specific user
  bool isLikedBy(String userId) {
    return likedBy.contains(userId);
  }

  /// Check if comment is deleted
  bool get isDeleted => deletedAt != null;

  /// Create a copy of this comment with updated fields
  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? parentCommentId,
    String? content,
    List<Media>? media,
    int? likes,
    List<String>? likedBy,
    List<String>? replies,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    List<String>? mentions,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      content: content ?? this.content,
      media: media ?? this.media,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      replies: replies ?? this.replies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      mentions: mentions ?? this.mentions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, likes: $likes)';
  }
}
  
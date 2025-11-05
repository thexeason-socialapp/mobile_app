import 'package:thexeasonapp/domain/entities/media.dart';
import 'package:thexeasonapp/domain/entities/post.dart';

/// 🧵 THREAD ENTITY
/// Pure Dart class representing a short-form text post (Twitter-style)
/// Supports nested replies and max 280 characters
/// No dependencies on external packages

class Thread {
  final String id;
  final String userId;
  final String content; // max 280 chars
  final Media? media; // optional single image/video
  final List<String> replies; // IDs of reply threads
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final PostVisibility visibility;
  final String? parentThreadId; // for nested replies

  const Thread({
    required this.id,
    required this.userId,
    required this.content,
    this.media,
    this.replies = const [],
    this.likes = 0,
    this.likedBy = const [],
    required this.createdAt,
    this.visibility = PostVisibility.public,
    this.parentThreadId,
  });

  /// Check if this is a top-level thread (not a reply)
  bool get isTopLevel => parentThreadId == null;

  /// Check if this thread has replies
  bool get hasReplies => replies.isNotEmpty;

  /// Check if this thread is liked by a specific user
  bool isLikedBy(String userId) {
    return likedBy.contains(userId);
  }

  /// Check if content exceeds character limit
  bool get exceedsLimit => content.length > 280;

  /// Create a copy of this thread with updated fields
  Thread copyWith({
    String? id,
    String? userId,
    String? content,
    Media? media,
    List<String>? replies,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
    PostVisibility? visibility,
    String? parentThreadId,
  }) {
    return Thread(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      media: media ?? this.media,
      replies: replies ?? this.replies,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      visibility: visibility ?? this.visibility,
      parentThreadId: parentThreadId ?? this.parentThreadId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Thread && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Thread(id: $id, userId: $userId, likes: $likes, replies: ${replies.length})';
  }
}
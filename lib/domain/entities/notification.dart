/// 🔔 NOTIFICATION ENTITY
/// Pure Dart class representing a notification
/// Supports likes, comments, follows, messages, and mentions
/// No dependencies on external packages

enum NotificationType {
  like,
  comment,
  follow,
  message,
  mention,
  reply,
  share,
}

class Notification {
  final String id;
  final String userId; // recipient
  final NotificationType type;
  final String fromUserId;
  final String? postId;
  final String? commentId;
  final String? messageId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final String? actionUrl; // deep link URL
  final String? imageUrl; // optional image for the notification

  const Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.fromUserId,
    this.postId,
    this.commentId,
    this.messageId,
    required this.title,
    required this.body,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    this.actionUrl,
    this.imageUrl,
  });

  /// Check if notification has been read
  bool get wasRead => isRead && readAt != null;

  /// Get notification age in hours
  int get ageInHours {
    return DateTime.now().difference(createdAt).inHours;
  }

  /// Check if notification is recent (less than 24 hours old)
  bool get isRecent => ageInHours < 24;

  /// Create a copy of this notification with updated fields
  Notification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? fromUserId,
    String? postId,
    String? commentId,
    String? messageId,
    String? title,
    String? body,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    String? actionUrl,
    String? imageUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      fromUserId: fromUserId ?? this.fromUserId,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      messageId: messageId ?? this.messageId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Notification(id: $id, type: $type, from: $fromUserId, isRead: $isRead)';
  }
}
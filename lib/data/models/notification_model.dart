import '../../domain/entities/notification.dart';

/// Data model for Notification with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.fromUserId,
    super.postId,
    super.commentId,
    super.messageId,
    required super.title,
    required super.body,
    super.isRead,
    super.readAt,
    required super.createdAt,
    super.actionUrl,
    super.imageUrl,
  });

  factory NotificationModel.fromEntity(Notification entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      fromUserId: entity.fromUserId,
      postId: entity.postId,
      commentId: entity.commentId,
      messageId: entity.messageId,
      title: entity.title,
      body: entity.body,
      isRead: entity.isRead,
      readAt: entity.readAt,
      createdAt: entity.createdAt,
      actionUrl: entity.actionUrl,
      imageUrl: entity.imageUrl,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: _parseNotificationType(json['type'] as String),
      fromUserId: json['fromUserId'] as String,
      postId: json['postId'] as String?,
      commentId: json['commentId'] as String?,
      messageId: json['messageId'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actionUrl: json['actionUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'fromUserId': fromUserId,
      if (postId != null) 'postId': postId,
      if (commentId != null) 'commentId': commentId,
      if (messageId != null) 'messageId': messageId,
      'title': title,
      'body': body,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      type: type,
      fromUserId: fromUserId,
      postId: postId,
      commentId: commentId,
      messageId: messageId,
      title: title,
      body: body,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
      actionUrl: actionUrl,
      imageUrl: imageUrl,
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'message':
        return NotificationType.message;
      case 'mention':
        return NotificationType.mention;
      case 'reply':
        return NotificationType.reply;
      case 'share':
        return NotificationType.share;
      default:
        throw ArgumentError('Invalid notification type: $type');
    }
  }
}
import 'package:thexeasonapp/domain/entities/media.dart';

/// 💌 MESSAGE ENTITY
/// Pure Dart class representing a direct message
/// Supports text, images, videos, and voice notes
/// No dependencies on external packages

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final Media? media;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Map<String, List<String>> reactions; // emoji -> list of userIds
  final String? replyTo; // messageId for quoted replies
  final MessageStatus status;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.media,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.reactions = const {},
    this.replyTo,
    this.status = MessageStatus.sending,
  });

  /// Check if message is deleted
  bool get isDeleted => deletedAt != null;

  /// Check if message has media attachment
  bool get hasMedia => media != null;

  /// Check if message is a reply to another message
  bool get isReply => replyTo != null;

  /// Get total reaction count
  int get totalReactions {
    return reactions.values.fold(0, (sum, users) => sum + users.length);
  }

  /// Check if user has reacted to this message
  bool hasReactedBy(String userId) {
    return reactions.values.any((users) => users.contains(userId));
  }

  /// Create a copy of this message with updated fields
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? content,
    Media? media,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    Map<String, List<String>>? reactions,
    String? replyTo,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      media: media ?? this.media,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      reactions: reactions ?? this.reactions,
      replyTo: replyTo ?? this.replyTo,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, sender: $senderId, status: $status, isRead: $isRead)';
  }
}
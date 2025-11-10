import '../../domain/entities/message.dart';
import '../../domain/entities/media.dart';
import 'media_model.dart';

/// Data model for Message with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.receiverId,
    required super.content,
    super.media,
    super.isRead,
    super.readAt,
    required super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.reactions,
    super.replyTo,
    super.status,
  });

  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      content: entity.content,
      media: entity.media,
      isRead: entity.isRead,
      readAt: entity.readAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      reactions: entity.reactions,
      replyTo: entity.replyTo,
      status: entity.status,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      media: json['media'] != null
          ? MediaModel.fromJson(json['media'] as Map<String, dynamic>)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      reactions: json['reactions'] != null
          ? Map<String, List<String>>.from(
              (json['reactions'] as Map).map(
                (key, value) => MapEntry(
                  key as String,
                  (value as List<dynamic>).map((e) => e as String).toList(),
                ),
              ),
            )
          : const {},
      replyTo: json['replyTo'] as String?,
      status: _parseMessageStatus(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      if (media != null) 'media': MediaModel.fromEntity(media!).toJson(),
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'reactions': reactions,
      if (replyTo != null) 'replyTo': replyTo,
      'status': status.name,
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      media: media,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      reactions: reactions,
      replyTo: replyTo,
      status: status,
    );
  }

  static MessageStatus _parseMessageStatus(String? status) {
    if (status == null) return MessageStatus.sending;
    
    switch (status.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sending;
    }
  }
}
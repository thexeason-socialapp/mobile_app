import '../../domain/entities/conversation.dart';

/// Data model for Conversation with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.participants,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.lastMessageSenderId,
    super.unreadCount,
    required super.createdAt,
    super.archivedBy,
    super.mutedBy,
    super.isActive,
  });

  factory ConversationModel.fromEntity(Conversation entity) {
    return ConversationModel(
      id: entity.id,
      participants: entity.participants,
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
      lastMessageSenderId: entity.lastMessageSenderId,
      unreadCount: entity.unreadCount,
      createdAt: entity.createdAt,
      archivedBy: entity.archivedBy,
      mutedBy: entity.mutedBy,
      isActive: entity.isActive,
    );
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      lastMessageSenderId: json['lastMessageSenderId'] as String,
      unreadCount: Map<String, int>.from(
        (json['unreadCount'] as Map? ?? {}).map(
          (key, value) => MapEntry(key as String, value as int),
        ),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      archivedBy: (json['archivedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      mutedBy: (json['mutedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
      'archivedBy': archivedBy,
      'mutedBy': mutedBy,
      'isActive': isActive,
    };
  }

  Conversation toEntity() {
    return Conversation(
      id: id,
      participants: participants,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      lastMessageSenderId: lastMessageSenderId,
      unreadCount: unreadCount,
      createdAt: createdAt,
      archivedBy: archivedBy,
      mutedBy: mutedBy,
      isActive: isActive,
    );
  }
}
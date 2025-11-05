/// 💬 CONVERSATION ENTITY
/// Pure Dart class representing a conversation between users
/// Manages metadata about message threads
/// No dependencies on external packages

class Conversation {
  final String id;
  final List<String> participants; // exactly 2 for MVP (1-to-1 chat)
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final Map<String, int> unreadCount; // userId -> unread count
  final DateTime createdAt;
  final List<String> archivedBy; // userIds who archived this conversation
  final List<String> mutedBy; // userIds who muted notifications
  final bool isActive;

  const Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    this.unreadCount = const {},
    required this.createdAt,
    this.archivedBy = const [],
    this.mutedBy = const [],
    this.isActive = true,
  });

  /// Get the other participant's ID (for 1-to-1 chat)
  String? getOtherParticipantId(String currentUserId) {
    if (participants.length != 2) return null;
    return participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  /// Get unread count for a specific user
  int getUnreadCountFor(String userId) {
    return unreadCount[userId] ?? 0;
  }

  /// Check if conversation is archived by a user
  bool isArchivedBy(String userId) {
    return archivedBy.contains(userId);
  }

  /// Check if conversation is muted by a user
  bool isMutedBy(String userId) {
    return mutedBy.contains(userId);
  }

  /// Check if conversation has unread messages for a user
  bool hasUnreadFor(String userId) {
    return getUnreadCountFor(userId) > 0;
  }

  /// Create a copy of this conversation with updated fields
  Conversation copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    Map<String, int>? unreadCount,
    DateTime? createdAt,
    List<String>? archivedBy,
    List<String>? mutedBy,
    bool? isActive,
  }) {
    return Conversation(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      archivedBy: archivedBy ?? this.archivedBy,
      mutedBy: mutedBy ?? this.mutedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Conversation(id: $id, participants: $participants, lastMessage: $lastMessage)';
  }
}
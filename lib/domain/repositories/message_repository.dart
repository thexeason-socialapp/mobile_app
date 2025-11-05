/// 💌 MESSAGE REPOSITORY INTERFACE
/// Abstract contract defining messaging operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/message.dart';
import '../entities/conversation.dart';
import '../entities/media.dart';

abstract class MessageRepository {
  /// Get all conversations for a user
  /// Returns list of [Conversation] objects
  /// Supports pagination
  Future<List<Conversation>> getConversations({
    required String userId,
    int limit = 20,
    String? lastConversationId,
  });

  /// Get a specific conversation by ID
  /// Returns [Conversation] if found, throws exception if not found
  Future<Conversation> getConversationById(String conversationId);

  /// Get or create a conversation between two users
  /// Returns existing conversation or creates a new one
  Future<Conversation> getOrCreateConversation({
    required String userId1,
    required String userId2,
  });

  /// Get messages in a conversation
  /// Returns list of [Message] objects
  /// Supports pagination
  Future<List<Message>> getMessages({
    required String conversationId,
    int limit = 50,
    String? lastMessageId,
  });

  /// Get a single message by ID
  /// Returns [Message] if found, throws exception if not found
  Future<Message> getMessageById(String messageId);

  /// Send a text message
  /// Returns the created [Message]
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaPath,
    String? replyToMessageId,
  });

  /// Send a media message (image, video, voice)
  /// Uploads media first, then sends message
  /// Returns the created [Message]
  Future<Message> sendMediaMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String mediaPath,
    required MediaType mediaType,
    String? caption,
  });

  /// Delete a message
  /// Soft delete (marks as deleted but doesn't remove from DB)
  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  });

  /// Mark message as read
  /// Updates isRead and readAt fields
  Future<void> markAsRead({
    required String messageId,
    required String userId,
  });

  /// Mark all messages in a conversation as read
  /// Updates all unread messages at once
  Future<void> markConversationAsRead({
    required String conversationId,
    required String userId,
  });

  /// Add reaction to a message
  /// Supports emoji reactions
  Future<void> addReaction({
    required String messageId,
    required String userId,
    required String emoji,
  });

  /// Remove reaction from a message
  Future<void> removeReaction({
    required String messageId,
    required String userId,
    required String emoji,
  });

  /// Archive a conversation
  /// Hides conversation from main list
  Future<void> archiveConversation({
    required String conversationId,
    required String userId,
  });

  /// Unarchive a conversation
  Future<void> unarchiveConversation({
    required String conversationId,
    required String userId,
  });

  /// Mute conversation notifications
  Future<void> muteConversation({
    required String conversationId,
    required String userId,
  });

  /// Unmute conversation notifications
  Future<void> unmuteConversation({
    required String conversationId,
    required String userId,
  });

  /// Search messages by content
  /// Returns list of [Message] objects matching the query
  Future<List<Message>> searchMessages({
    required String userId,
    required String query,
    int limit = 20,
  });

  /// Listen to new messages in a conversation (real-time)
  /// Returns a stream of [Message] objects
  Stream<Message> listenToMessages(String conversationId);

  /// Listen to typing indicator
  /// Returns a stream indicating if the other user is typing
  Stream<bool> listenToTypingIndicator({
    required String conversationId,
    required String userId,
  });

  /// Send typing indicator
  /// Notifies the other user that you're typing
  Future<void> sendTypingIndicator({
    required String conversationId,
    required String userId,
    required bool isTyping,
  });
}
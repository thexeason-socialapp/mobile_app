// / 💬 COMMENT REPOSITORY INTERFACE
/// Abstract contract defining comment operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/comment.dart';

abstract class CommentRepository {
  /// Get comments for a specific post
  /// Returns list of [Comment] objects
  /// Supports pagination
  Future<List<Comment>> getCommentsByPost({
    required String postId,
    int limit = 20,
    String? lastCommentId,
  });

  /// Get a single comment by ID
  /// Returns [Comment] if found, throws exception if not found
  Future<Comment> getCommentById(String commentId);

  /// Get replies to a specific comment
  /// Returns list of [Comment] objects (nested replies)
  Future<List<Comment>> getRepliesByComment({
    required String commentId,
    int limit = 10,
  });

  /// Add a comment to a post
  /// Returns the created [Comment]
  Future<Comment> addComment({
    required String postId,
    required String userId,
    required String content,
    List<String>? mediaPaths,
  });

  /// Add a reply to a comment
  /// Returns the created [Comment]
  Future<Comment> addReply({
    required String commentId,
    required String postId,
    required String userId,
    required String content,
  });

  /// Update a comment
  /// Only content can be updated
  /// Returns updated [Comment]
  Future<Comment> updateComment({
    required String commentId,
    required String content,
  });

  /// Delete a comment
  /// Also deletes all replies to this comment
  Future<void> deleteComment(String commentId);

  /// Like a comment
  /// Increments like count and adds user to likedBy list
  Future<void> likeComment({
    required String commentId,
    required String userId,
  });

  /// Unlike a comment
  /// Decrements like count and removes user from likedBy list
  Future<void> unlikeComment({
    required String commentId,
    required String userId,
  });

  /// Get comments by a specific user
  /// Returns list of [Comment] objects
  /// Supports pagination
  Future<List<Comment>> getCommentsByUser({
    required String userId,
    int limit = 20,
    String? lastCommentId,
  });

  /// Report a comment for violating community guidelines
  Future<void> reportComment({
    required String commentId,
    required String userId,
    required String reason,
  });
}
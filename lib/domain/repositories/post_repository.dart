/// 📝 POST REPOSITORY INTERFACE
/// Abstract contract defining post operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/post.dart';

abstract class PostRepository {
  /// Get feed posts (chronological or algorithmic)
  /// Returns list of [Post] objects
  /// Supports pagination
  Future<List<Post>> getFeedPosts({
    required String userId,
    int limit = 20,
    String? lastPostId,
  });

  /// Get a single post by ID
  /// Returns [Post] if found, throws exception if not found
  Future<Post> getPostById(String postId);

  /// Get posts by a specific user
  /// Returns list of [Post] objects
  /// Supports pagination
  Future<List<Post>> getPostsByUser({
    required String userId,
    int limit = 20,
    String? lastPostId,
  });

  /// Create a new post
  /// Uploads media if present, then creates post document
  /// Returns the created [Post]
  Future<Post> createPost({
    required String userId,
    required String content,
    List<String>? mediaPaths,
    PostVisibility visibility = PostVisibility.public,
  });

  /// Update an existing post
  /// Only content can be updated (media cannot be changed)
  /// Returns updated [Post]
  Future<Post> updatePost({
    required String postId,
    required String content,
  });

  /// Delete a post
  /// Also deletes all comments and likes associated with the post
  Future<void> deletePost(String postId);

  /// Like a post
  /// Increments like count and adds user to likedBy list
  Future<void> likePost({
    required String postId,
    required String userId,
  });

  /// Unlike a post
  /// Decrements like count and removes user from likedBy list
  Future<void> unlikePost({
    required String postId,
    required String userId,
  });

  /// Get posts liked by a user
  /// Returns list of [Post] objects
  /// Supports pagination
  Future<List<Post>> getLikedPosts({
    required String userId,
    int limit = 20,
    String? lastPostId,
  });

  /// Share a post (repost)
  /// Creates a new post that references the original
  Future<Post> sharePost({
    required String postId,
    required String userId,
    String? comment,
  });

  /// Get trending posts
  /// Returns posts with high engagement in the last 24 hours
  Future<List<Post>> getTrendingPosts({
    int limit = 20,
    String? lastPostId,
  });

  /// Search posts by content or hashtags
  /// Returns list of [Post] objects matching the query
  Future<List<Post>> searchPosts({
    required String query,
    int limit = 20,
    String? lastPostId,
  });

  /// Get posts by hashtag
  /// Returns list of [Post] objects with the specified hashtag
  Future<List<Post>> getPostsByHashtag({
    required String hashtag,
    int limit = 20,
    String? lastPostId,
  });

  /// Get post statistics
  /// Returns map with stats like views, impressions, engagement
  Future<PostMetadata> getPostStats(String postId);

  /// Report a post for violating community guidelines
  Future<void> reportPost({
    required String postId,
    required String userId,
    required String reason,
  });
}
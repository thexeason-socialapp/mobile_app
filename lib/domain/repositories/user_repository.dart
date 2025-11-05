/// 👤 USER REPOSITORY INTERFACE
/// Abstract contract defining user profile operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/user.dart';

abstract class UserRepository {
  /// Get user profile by ID
  /// Returns [User] if found, throws exception if not found
  Future<User> getUserById(String userId);

  /// Get user profile by username
  /// Returns [User] if found, throws exception if not found
  Future<User> getUserByUsername(String username);

  /// Update user profile
  /// Returns updated [User] on success
  Future<User> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? location,
    String? website,
    String? phone,
  });

  /// Upload user avatar
  /// Uploads image to storage and updates user profile
  /// Returns the new avatar URL
  Future<String> uploadAvatar({
    required String userId,
    required String imagePath,
  });

  /// Upload user banner
  /// Uploads image to storage and updates user profile
  /// Returns the new banner URL
  Future<String> uploadBanner({
    required String userId,
    required String imagePath,
  });

  /// Follow a user
  /// Updates follower/following counts for both users
  Future<void> followUser({
    required String followerId,
    required String followingId,
  });

  /// Unfollow a user
  /// Updates follower/following counts for both users
  Future<void> unfollowUser({
    required String followerId,
    required String followingId,
  });

  /// Get list of followers for a user
  /// Returns list of [User] objects
  /// Supports pagination
  Future<List<User>> getFollowers({
    required String userId,
    int limit = 20,
    String? lastUserId,
  });

  /// Get list of users that a user is following
  /// Returns list of [User] objects
  /// Supports pagination
  Future<List<User>> getFollowing({
    required String userId,
    int limit = 20,
    String? lastUserId,
  });

  /// Check if userA is following userB
  /// Returns true if following, false otherwise
  Future<bool> isFollowing({
    required String followerId,
    required String followingId,
  });

  /// Block a user
  /// Prevents the blocked user from interacting with the blocker
  Future<void> blockUser({
    required String blockerId,
    required String blockedId,
  });

  /// Unblock a user
  Future<void> unblockUser({
    required String blockerId,
    required String blockedId,
  });

  /// Get list of blocked users
  /// Returns list of user IDs
  Future<List<String>> getBlockedUsers(String userId);

  /// Search users by username or display name
  /// Returns list of [User] objects matching the query
  Future<List<User>> searchUsers({
    required String query,
    int limit = 20,
    String? lastUserId,
  });

  /// Update user preferences
  /// Returns updated [User] with new preferences
  Future<User> updatePreferences({
    required String userId,
    required UserPreferences preferences,
  });

  /// Get user statistics
  /// Returns map with stats like posts, likes, comments
  Future<Map<String, int>> getUserStats(String userId);
}
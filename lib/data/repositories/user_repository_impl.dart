import 'package:logger/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/rest_api/users_api.dart';
import '../datasources/local/boxes/user_box.dart';
import '../models/user_model.dart';

/// =d USER REPOSITORY IMPLEMENTATION
/// Implements UserRepository with network-first strategy and local caching
/// Uses Firestore for remote data and Hive for offline caching
class UserRepositoryImpl implements UserRepository {
  final UsersApi _usersApi;
  final UserBox _userBox;
  final Logger _logger;

  UserRepositoryImpl({
    required UsersApi usersApi,
    required UserBox userBox,
    Logger? logger,
  })  : _usersApi = usersApi,
        _userBox = userBox,
        _logger = logger ?? Logger();

  // ========================================
  // PROFILE OPERATIONS
  // ========================================

  @override
  Future<User> getUserById(String userId) async {
    try {
      // Try to fetch from network first
      final userModel = await _usersApi.getUserById(userId);

      // Cache the user data locally
      await _userBox.saveUser(userModel);

      return userModel.toEntity();
    } catch (e) {
      _logger.w('Network fetch failed, trying local cache: $e');

      // Fallback to local cache if network fails
      final cachedUser = await _userBox.getUser(userId);
      if (cachedUser != null) {
        _logger.i('Returning cached user data for: $userId');
        return cachedUser.toEntity();
      }

      // No cache available, rethrow error
      _logger.e('No cached data available for user: $userId');
      rethrow;
    }
  }

  @override
  Future<User> getUserByUsername(String username) async {
    try {
      // Fetch from network
      final userModel = await _usersApi.getUserByUsername(username);

      // Cache the user data
      await _userBox.saveUser(userModel);

      return userModel.toEntity();
    } catch (e) {
      _logger.e('Error fetching user by username: $e');
      rethrow;
    }
  }

  @override
  Future<User> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? location,
    String? website,
    String? phone,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (displayName != null) updates['displayName'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (location != null) updates['location'] = location;
      if (website != null) updates['website'] = website;
      if (phone != null) updates['phone'] = phone;

      final updatedUser = await _usersApi.updateProfile(
        userId: userId,
        updates: updates,
      );

      // Update local cache
      await _userBox.saveUser(updatedUser);

      return updatedUser.toEntity();
    } catch (e) {
      _logger.e('Error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final avatarUrl = await _usersApi.uploadAvatar(
        userId: userId,
        filePath: imagePath,
      );

      // Refresh user data in cache
      final updatedUser = await _usersApi.getUserById(userId);
      await _userBox.saveUser(updatedUser);

      return avatarUrl;
    } catch (e) {
      _logger.e('Error uploading avatar: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadBanner({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final bannerUrl = await _usersApi.uploadBanner(
        userId: userId,
        filePath: imagePath,
      );

      // Refresh user data in cache
      final updatedUser = await _usersApi.getUserById(userId);
      await _userBox.saveUser(updatedUser);

      return bannerUrl;
    } catch (e) {
      _logger.e('Error uploading banner: $e');
      rethrow;
    }
  }

  // ========================================
  // FOLLOW/UNFOLLOW OPERATIONS
  // ========================================

  @override
  Future<void> followUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await _usersApi.followUser(
        followerId: followerId,
        followingId: followingId,
      );

      // Invalidate cache for both users to get updated counts
      await _refreshUserCache(followerId);
      await _refreshUserCache(followingId);
    } catch (e) {
      _logger.e('Error following user: $e');
      rethrow;
    }
  }

  @override
  Future<void> unfollowUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await _usersApi.unfollowUser(
        followerId: followerId,
        followingId: followingId,
      );

      // Invalidate cache for both users
      await _refreshUserCache(followerId);
      await _refreshUserCache(followingId);
    } catch (e) {
      _logger.e('Error unfollowing user: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isFollowing({
    required String followerId,
    required String followingId,
  }) async {
    try {
      return await _usersApi.isFollowing(
        followerId: followerId,
        followingId: followingId,
      );
    } catch (e) {
      _logger.e('Error checking follow status: $e');
      rethrow;
    }
  }

  @override
  Future<List<User>> getFollowers({
    required String userId,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      final followers = await _usersApi.getFollowers(
        userId: userId,
        limit: limit,
        lastUserId: lastUserId,
      );

      // Cache each follower
      for (final follower in followers) {
        await _userBox.saveUser(follower);
      }

      return followers.map((f) => f.toEntity()).toList();
    } catch (e) {
      _logger.e('Error fetching followers: $e');
      rethrow;
    }
  }

  @override
  Future<List<User>> getFollowing({
    required String userId,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      final following = await _usersApi.getFollowing(
        userId: userId,
        limit: limit,
        lastUserId: lastUserId,
      );

      // Cache each user
      for (final user in following) {
        await _userBox.saveUser(user);
      }

      return following.map((u) => u.toEntity()).toList();
    } catch (e) {
      _logger.e('Error fetching following: $e');
      rethrow;
    }
  }

  // ========================================
  // BLOCK OPERATIONS
  // ========================================

  @override
  Future<void> blockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      await _usersApi.blockUser(
        blockerId: blockerId,
        blockedId: blockedId,
      );

      // Refresh blocker's cache
      await _refreshUserCache(blockerId);
    } catch (e) {
      _logger.e('Error blocking user: $e');
      rethrow;
    }
  }

  @override
  Future<void> unblockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      await _usersApi.unblockUser(
        blockerId: blockerId,
        blockedId: blockedId,
      );

      // Refresh blocker's cache
      await _refreshUserCache(blockerId);
    } catch (e) {
      _logger.e('Error unblocking user: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getBlockedUsers(String userId) async {
    try {
      return await _usersApi.getBlockedUsers(userId);
    } catch (e) {
      _logger.e('Error fetching blocked users: $e');
      rethrow;
    }
  }

  // ========================================
  // SEARCH OPERATIONS
  // ========================================

  @override
  Future<List<User>> searchUsers({
    required String query,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      final users = await _usersApi.searchUsers(
        query: query,
        limit: limit,
        lastUserId: lastUserId,
      );

      // Cache search results
      for (final user in users) {
        await _userBox.saveUser(user);
      }

      return users.map((u) => u.toEntity()).toList();
    } catch (e) {
      _logger.e('Error searching users: $e');
      rethrow;
    }
  }

  // ========================================
  // PREFERENCES & STATS
  // ========================================

  @override
  Future<User> updatePreferences({
    required String userId,
    required UserPreferences preferences,
  }) async {
    try {
      final updates = {
        'preferences': UserPreferencesModel.fromEntity(preferences).toJson(),
      };

      final updatedUser = await _usersApi.updateProfile(
        userId: userId,
        updates: updates,
      );

      // Update cache
      await _userBox.saveUser(updatedUser);

      return updatedUser.toEntity();
    } catch (e) {
      _logger.e('Error updating preferences: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      return await _usersApi.getUserStats(userId);
    } catch (e) {
      _logger.e('Error fetching user stats: $e');
      rethrow;
    }
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Refresh user data in cache
  Future<void> _refreshUserCache(String userId) async {
    try {
      final updatedUser = await _usersApi.getUserById(userId);
      await _userBox.saveUser(updatedUser);
    } catch (e) {
      _logger.w('Failed to refresh cache for user $userId: $e');
      // Don't rethrow - cache refresh is best-effort
    }
  }
}

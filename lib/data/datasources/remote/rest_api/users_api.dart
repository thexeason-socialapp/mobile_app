import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import '../../../models/user_model.dart';

/// =d USERS API
/// Handles all user-related Firestore operations
/// Uses Firebase Storage for avatar/banner uploads
class UsersApi {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Logger _logger;

  // Collection names
  static const String _usersCollection = 'users';
  static const String _followersSubcollection = 'followers';
  static const String _followingSubcollection = 'following';

  // Storage paths
  static const String _avatarsStoragePath = 'avatars';
  static const String _bannersStoragePath = 'banners';

  UsersApi({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Logger? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _logger = logger ?? Logger();

  // ========================================
  // USER PROFILE OPERATIONS
  // ========================================

  /// Get user by ID
  Future<UserModel> getUserById(String userId) async {
    try {
      _logger.i('Fetching user by ID: $userId');

      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw Exception('User not found: $userId');
      }

      final data = doc.data()!;
      data['id'] = doc.id; // Ensure ID is included

      return UserModel.fromJson(data);
    } catch (e) {
      _logger.e('Error fetching user by ID: $e');
      rethrow;
    }
  }

  /// Get user by username
  Future<UserModel> getUserByUsername(String username) async {
    try {
      _logger.i('Fetching user by username: $username');

      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found: $username');
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;

      return UserModel.fromJson(data);
    } catch (e) {
      _logger.e('Error fetching user by username: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      _logger.i('Updating profile for user: $userId');

      if (updates == null || updates.isEmpty) {
        return await getUserById(userId);
      }

      // Add updatedAt timestamp
      final updateData = {
        ...updates,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update(updateData);

      return await getUserById(userId);
    } catch (e) {
      _logger.e('Error updating profile: $e');
      rethrow;
    }
  }

  /// Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      _logger.e('Error checking username availability: $e');
      rethrow;
    }
  }

  // ========================================
  // MEDIA UPLOAD OPERATIONS
  // ========================================

  /// Upload avatar to Firebase Storage
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
    Function(double progress)? onProgress,
  }) async {
    try {
      _logger.i('Uploading avatar for user: $userId');

      final file = File(filePath);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('$_avatarsStoragePath/$fileName');

      // Upload with progress tracking
      final uploadTask = ref.putFile(file);

      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      // Update user document with new avatar URL
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'avatar': downloadUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _logger.i('Avatar uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Error uploading avatar: $e');
      rethrow;
    }
  }

  /// Upload banner to Firebase Storage
  Future<String> uploadBanner({
    required String userId,
    required String filePath,
    Function(double progress)? onProgress,
  }) async {
    try {
      _logger.i('Uploading banner for user: $userId');

      final file = File(filePath);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('$_bannersStoragePath/$fileName');

      // Upload with progress tracking
      final uploadTask = ref.putFile(file);

      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      // Update user document with new banner URL
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'banner': downloadUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _logger.i('Banner uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Error uploading banner: $e');
      rethrow;
    }
  }

  /// Delete image from storage
  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      _logger.i('Image deleted from storage: $imageUrl');
    } catch (e) {
      _logger.e('Error deleting image from storage: $e');
      // Don't rethrow - deletion failure shouldn't block other operations
    }
  }

  /// Update user avatar URL (for Cloudinary uploads)
  /// Saves the Cloudinary URL to the user's Firestore document
  /// Returns the updated user model with new avatar URL
  Future<UserModel> updateUserAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    try {
      _logger.i('Updating avatar URL for user: $userId');
      _logger.d('Avatar URL: $avatarUrl');

      // Update user document with new avatar URL
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'avatar': avatarUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _logger.i('Avatar URL updated successfully');

      // Return updated user
      return await getUserById(userId);
    } catch (e) {
      _logger.e('Error updating avatar URL: $e');
      rethrow;
    }
  }

  /// Update user banner URL (for Cloudinary uploads)
  /// Saves the Cloudinary URL to the user's Firestore document
  /// Returns the updated user model with new banner URL
  Future<UserModel> updateUserBannerUrl({
    required String userId,
    required String bannerUrl,
  }) async {
    try {
      _logger.i('Updating banner URL for user: $userId');
      _logger.d('Banner URL: $bannerUrl');

      // Update user document with new banner URL
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'banner': bannerUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _logger.i('Banner URL updated successfully');

      // Return updated user
      return await getUserById(userId);
    } catch (e) {
      _logger.e('Error updating banner URL: $e');
      rethrow;
    }
  }

  // ========================================
  // FOLLOW/UNFOLLOW OPERATIONS
  // ========================================

  /// Follow a user
  Future<void> followUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      _logger.i('User $followerId following $followingId');

      if (followerId == followingId) {
        throw Exception('Cannot follow yourself');
      }

      final batch = _firestore.batch();

      // Add to follower's following subcollection
      final followingRef = _firestore
          .collection(_usersCollection)
          .doc(followerId)
          .collection(_followingSubcollection)
          .doc(followingId);

      batch.set(followingRef, {
        'userId': followingId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      // Add to followed user's followers subcollection
      final followerRef = _firestore
          .collection(_usersCollection)
          .doc(followingId)
          .collection(_followersSubcollection)
          .doc(followerId);

      batch.set(followerRef, {
        'userId': followerId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      // Increment following count for follower
      final followerDocRef = _firestore
          .collection(_usersCollection)
          .doc(followerId);

      batch.update(followerDocRef, {
        'following': FieldValue.increment(1),
      });

      // Increment followers count for followed user
      final followingDocRef = _firestore
          .collection(_usersCollection)
          .doc(followingId);

      batch.update(followingDocRef, {
        'followers': FieldValue.increment(1),
      });

      await batch.commit();
      _logger.i('Follow operation completed successfully');
    } catch (e) {
      _logger.e('Error following user: $e');
      rethrow;
    }
  }

  /// Unfollow a user
  Future<void> unfollowUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      _logger.i('User $followerId unfollowing $followingId');

      final batch = _firestore.batch();

      // Remove from follower's following subcollection
      final followingRef = _firestore
          .collection(_usersCollection)
          .doc(followerId)
          .collection(_followingSubcollection)
          .doc(followingId);

      batch.delete(followingRef);

      // Remove from followed user's followers subcollection
      final followerRef = _firestore
          .collection(_usersCollection)
          .doc(followingId)
          .collection(_followersSubcollection)
          .doc(followerId);

      batch.delete(followerRef);

      // Decrement following count for follower
      final followerDocRef = _firestore
          .collection(_usersCollection)
          .doc(followerId);

      batch.update(followerDocRef, {
        'following': FieldValue.increment(-1),
      });

      // Decrement followers count for followed user
      final followingDocRef = _firestore
          .collection(_usersCollection)
          .doc(followingId);

      batch.update(followingDocRef, {
        'followers': FieldValue.increment(-1),
      });

      await batch.commit();
      _logger.i('Unfollow operation completed successfully');
    } catch (e) {
      _logger.e('Error unfollowing user: $e');
      rethrow;
    }
  }

  /// Check if user is following another user
  Future<bool> isFollowing({
    required String followerId,
    required String followingId,
  }) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(followerId)
          .collection(_followingSubcollection)
          .doc(followingId)
          .get();

      return doc.exists;
    } catch (e) {
      _logger.e('Error checking follow status: $e');
      rethrow;
    }
  }

  // ========================================
  // FOLLOWERS/FOLLOWING LISTS
  // ========================================

  /// Get list of followers
  Future<List<UserModel>> getFollowers({
    required String userId,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      _logger.i('Fetching followers for user: $userId');

      Query query = _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_followersSubcollection)
          .orderBy('followedAt', descending: true)
          .limit(limit);

      if (lastUserId != null) {
        final lastDoc = await _firestore
            .collection(_usersCollection)
            .doc(userId)
            .collection(_followersSubcollection)
            .doc(lastUserId)
            .get();

        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();

      // Get full user data for each follower
      final List<UserModel> followers = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['userId'] != null) {
          final followerUserId = data['userId'] as String;
          final user = await getUserById(followerUserId);
          followers.add(user);
        }
      }

      return followers;
    } catch (e) {
      _logger.e('Error fetching followers: $e');
      rethrow;
    }
  }

  /// Get list of following
  Future<List<UserModel>> getFollowing({
    required String userId,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      _logger.i('Fetching following for user: $userId');

      Query query = _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_followingSubcollection)
          .orderBy('followedAt', descending: true)
          .limit(limit);

      if (lastUserId != null) {
        final lastDoc = await _firestore
            .collection(_usersCollection)
            .doc(userId)
            .collection(_followingSubcollection)
            .doc(lastUserId)
            .get();

        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();

      // Get full user data for each following
      final List<UserModel> following = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['userId'] != null) {
          final followingUserId = data['userId'] as String;
          final user = await getUserById(followingUserId);
          following.add(user);
        }
      }

      return following;
    } catch (e) {
      _logger.e('Error fetching following: $e');
      rethrow;
    }
  }

  // ========================================
  // SEARCH OPERATIONS
  // ========================================

  /// Search users by username or display name
  Future<List<UserModel>> searchUsers({
    required String query,
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      _logger.i('Searching users with query: $query');

      final lowercaseQuery = query.toLowerCase();

      // Search by username (starts with query)
      Query firestoreQuery = _firestore
          .collection(_usersCollection)
          .where('username', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('username', isLessThan: '${lowercaseQuery}z')
          .limit(limit);

      if (lastUserId != null) {
        final lastDoc = await _firestore
            .collection(_usersCollection)
            .doc(lastUserId)
            .get();

        if (lastDoc.exists) {
          firestoreQuery = firestoreQuery.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await firestoreQuery.get();

      final users = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }).toList();

      return users;
    } catch (e) {
      _logger.e('Error searching users: $e');
      rethrow;
    }
  }

  // ========================================
  // BLOCK OPERATIONS
  // ========================================

  /// Block a user
  Future<void> blockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      _logger.i('User $blockerId blocking $blockedId');

      await _firestore
          .collection(_usersCollection)
          .doc(blockerId)
          .update({
        'blockedUsers': FieldValue.arrayUnion([blockedId]),
      });

      // Also unfollow if following
      final isCurrentlyFollowing = await isFollowing(
        followerId: blockerId,
        followingId: blockedId,
      );

      if (isCurrentlyFollowing) {
        await unfollowUser(
          followerId: blockerId,
          followingId: blockedId,
        );
      }
    } catch (e) {
      _logger.e('Error blocking user: $e');
      rethrow;
    }
  }

  /// Unblock a user
  Future<void> unblockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      _logger.i('User $blockerId unblocking $blockedId');

      await _firestore
          .collection(_usersCollection)
          .doc(blockerId)
          .update({
        'blockedUsers': FieldValue.arrayRemove([blockedId]),
      });
    } catch (e) {
      _logger.e('Error unblocking user: $e');
      rethrow;
    }
  }

  /// Get blocked users list
  Future<List<String>> getBlockedUsers(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return [];
      }

      final data = doc.data()!;
      final blockedUsers = data['blockedUsers'] as List<dynamic>?;

      return blockedUsers?.map((e) => e as String).toList() ?? [];
    } catch (e) {
      _logger.e('Error fetching blocked users: $e');
      rethrow;
    }
  }

  // ========================================
  // STATISTICS
  // ========================================

  /// Get user statistics
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final user = await getUserById(userId);

      return {
        'posts': user.postsCount,
        'followers': user.followers,
        'following': user.following,
      };
    } catch (e) {
      _logger.e('Error fetching user stats: $e');
      rethrow;
    }
  }
}

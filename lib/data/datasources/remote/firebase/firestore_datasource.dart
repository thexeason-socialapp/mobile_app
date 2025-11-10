import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../models/comment_model.dart';
import '../../../models/conversation_model.dart';
import '../../../models/message_model.dart';
import '../../../models/notification_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import 'firebase_service.dart';

abstract class FirestoreDataSource {
  // Posts
  Future<List<PostModel>> getFeedPosts({required int page, required int limit});
  Future<PostModel> getPost(String postId);
  Future<String> createPost(PostModel post);
  Future<void> deletePost(String postId);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  
  // Comments
  Future<List<CommentModel>> getComments(String postId);
  Future<String> addComment(CommentModel comment);
  Future<void> deleteComment(String commentId);
  Future<void> likeComment(String commentId, String userId);
  
  // Users
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> followUser(String followerId, String followingId);
  Future<void> unfollowUser(String followerId, String followingId);
  Future<List<UserModel>> getFollowers(String userId);
  Future<List<UserModel>> getFollowing(String userId);
  
  // Messages
  Future<List<ConversationModel>> getConversations(String userId);
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<String> sendMessage(MessageModel message, String conversationId);
  Future<void> markMessageAsRead(String conversationId, String messageId);
  
  // Notifications
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> clearAllNotifications(String userId);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;
  
  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.instance.firestore;

  // ============ POSTS ============
  
  @override
  Future<List<PostModel>> getFeedPosts({
    required int page,
    required int limit,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .where('visibility', isEqualTo: 'public')
          .orderBy('createdAt', descending: true)
          .limit(limit);
      
      if (page > 0) {
        final lastDoc = await _getLastDocument(page, limit);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get feed: $e');
    }
  }
  
  @override
  Future<PostModel> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      
      if (!doc.exists) {
        throw const NotFoundException.postNotFound();
      }
      
      return PostModel.fromJson(doc.data()!);
      
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to get post: $e');
    }
  }
  
  @override
  Future<String> createPost(PostModel post) async {
    try {
      final docRef = _firestore.collection('posts').doc();
      final postData = post.toJson();
      postData['id'] = docRef.id;
      
      await docRef.set(postData);
      
      return docRef.id;
      
    } catch (e) {
      throw ServerException('Failed to create post: $e');
    }
  }
  
  @override
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw ServerException('Failed to delete post: $e');
    }
  }
  
  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      final batch = _firestore.batch();
      
      final postRef = _firestore.collection('posts').doc(postId);
      batch.update(postRef, {
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
      
      final likeRef = _firestore.collection('likes').doc();
      batch.set(likeRef, {
        'id': likeRef.id,
        'userId': userId,
        'postId': postId,
        'type': 'post',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
      
    } catch (e) {
      throw ServerException('Failed to like post: $e');
    }
  }
  
  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      final batch = _firestore.batch();
      
      final postRef = _firestore.collection('posts').doc(postId);
      batch.update(postRef, {
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
      
      final likeQuery = await _firestore
          .collection('likes')
          .where('userId', isEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .limit(1)
          .get();
      
      if (likeQuery.docs.isNotEmpty) {
        batch.delete(likeQuery.docs.first.reference);
      }
      
      await batch.commit();
      
    } catch (e) {
      throw ServerException('Failed to unlike post: $e');
    }
  }
  
  // ============ COMMENTS ============
  
  @override
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: false)
          .get();
      
      return snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get comments: $e');
    }
  }
  
  @override
  Future<String> addComment(CommentModel comment) async {
    try {
      final docRef = _firestore.collection('comments').doc();
      final commentData = comment.toJson();
      commentData['id'] = docRef.id;
      
      await docRef.set(commentData);
      
      return docRef.id;
      
    } catch (e) {
      throw ServerException('Failed to add comment: $e');
    }
  }
  
  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();
    } catch (e) {
      throw ServerException('Failed to delete comment: $e');
    }
  }
  
  @override
  Future<void> likeComment(String commentId, String userId) async {
    try {
      await _firestore.collection('comments').doc(commentId).update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw ServerException('Failed to like comment: $e');
    }
  }
  
  // ============ USERS ============
  
  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        throw const NotFoundException.userNotFound();
      }
      
      return UserModel.fromJson(doc.data()!);
      
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to get user: $e');
    }
  }
  
  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw ServerException('Failed to update user: $e');
    }
  }
  
  @override
  Future<void> followUser(String followerId, String followingId) async {
    try {
      final batch = _firestore.batch();
      
      final followRef = _firestore.collection('follows').doc();
      batch.set(followRef, {
        'id': followRef.id,
        'followerId': followerId,
        'followingId': followingId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
      
      final followerRef = _firestore.collection('users').doc(followerId);
      batch.update(followerRef, {
        'following': FieldValue.increment(1),
      });
      
      final followingRef = _firestore.collection('users').doc(followingId);
      batch.update(followingRef, {
        'followers': FieldValue.increment(1),
      });
      
      await batch.commit();
      
    } catch (e) {
      throw ServerException('Failed to follow user: $e');
    }
  }
  
  @override
  Future<void> unfollowUser(String followerId, String followingId) async {
    try {
      final batch = _firestore.batch();
      
      final followQuery = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: followerId)
          .where('followingId', isEqualTo: followingId)
          .limit(1)
          .get();
      
      if (followQuery.docs.isNotEmpty) {
        batch.delete(followQuery.docs.first.reference);
      }
      
      final followerRef = _firestore.collection('users').doc(followerId);
      batch.update(followerRef, {
        'following': FieldValue.increment(-1),
      });
      
      final followingRef = _firestore.collection('users').doc(followingId);
      batch.update(followingRef, {
        'followers': FieldValue.increment(-1),
      });
      
      await batch.commit();
      
    } catch (e) {
      throw ServerException('Failed to unfollow user: $e');
    }
  }
  
  @override
  Future<List<UserModel>> getFollowers(String userId) async {
    try {
      final followsSnapshot = await _firestore
          .collection('follows')
          .where('followingId', isEqualTo: userId)
          .get();
      
      final followerIds = followsSnapshot.docs
          .map((doc) => doc.data()['followerId'] as String)
          .toList();
      
      if (followerIds.isEmpty) return [];
      
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: followerIds)
          .get();
      
      return usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get followers: $e');
    }
  }
  
  @override
  Future<List<UserModel>> getFollowing(String userId) async {
    try {
      final followsSnapshot = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: userId)
          .get();
      
      final followingIds = followsSnapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toList();
      
      if (followingIds.isEmpty) return [];
      
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: followingIds)
          .get();
      
      return usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get following: $e');
    }
  }
  
  // ============ MESSAGES ============
  
  @override
  Future<List<ConversationModel>> getConversations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => ConversationModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get conversations: $e');
    }
  }
  
  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .get();
      
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get messages: $e');
    }
  }
  
  @override
  Future<String> sendMessage(MessageModel message, String conversationId) async {
    try {
      final docRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();
      
      final messageData = message.toJson();
      messageData['id'] = docRef.id;
      
      await docRef.set(messageData);
      
      return docRef.id;
      
    } catch (e) {
      throw ServerException('Failed to send message: $e');
    }
  }
  
  @override
  Future<void> markMessageAsRead(String conversationId, String messageId) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException('Failed to mark message as read: $e');
    }
  }
  
  // ============ NOTIFICATIONS ============
  
  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      
      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
          
    } catch (e) {
      throw ServerException('Failed to get notifications: $e');
    }
  }
  
  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException('Failed to mark notification as read: $e');
    }
  }
  
  @override
  Future<void> clearAllNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();
      
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
    } catch (e) {
      throw ServerException('Failed to clear notifications: $e');
    }
  }
  
  // ============ HELPER METHODS ============
  
  Future<DocumentSnapshot?> _getLastDocument(int page, int limit) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(page * limit)
          .get();
      
      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.last;
      
    } catch (e) {
      return null;
    }
  }
}
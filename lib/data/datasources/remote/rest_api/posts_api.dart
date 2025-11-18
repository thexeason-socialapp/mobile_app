import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import '../../../../domain/entities/post.dart';
import '../../../../domain/entities/media.dart';
import '../../../models/post_model.dart';

/// Posts API - Handles all post-related Firebase operations
class PostsApi {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Logger _logger;

  PostsApi({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required Logger logger,
  })  : _firestore = firestore,
        _storage = storage,
        _logger = logger;

  /// Get feed posts for a user (chronological order)
  Future<List<Post>> getFeedPosts({
    required String userId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      _logger.e('Error getting feed posts: $e');
      rethrow;
    }
  }

  /// Get a single post by ID
  Future<Post> getPostById(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        throw Exception('Post not found');
      }

      return PostModel.fromFirestore(doc).toEntity();
    } catch (e) {
      _logger.e('Error getting post: $e');
      rethrow;
    }
  }

  /// Get posts by a specific user
  Future<List<Post>> getPostsByUser({
    required String userId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      _logger.e('Error getting user posts: $e');
      rethrow;
    }
  }

  /// Create a new post
  Future<Post> createPost({
    required String userId,
    required String content,
    List<String>? mediaPaths,
    PostVisibility visibility = PostVisibility.public,
  }) async {
    try {
      final postRef = _firestore.collection('posts').doc();

      // Upload media if present
      final List<Media> mediaList = [];
      if (mediaPaths != null && mediaPaths.isNotEmpty) {
        for (final path in mediaPaths) {
          final mediaUrl = await _uploadMedia(postRef.id, path);
          mediaList.add(Media(
            type: _getMediaType(path),
            url: mediaUrl,
          ));
        }
      }

      final now = DateTime.now();
      final postModel = PostModel(
        id: postRef.id,
        userId: userId,
        content: content,
        media: mediaList,
        createdAt: now,
        visibility: visibility,
      );

      await postRef.set(postModel.toFirestore());

      return postModel.toEntity();
    } catch (e) {
      _logger.e('Error creating post: $e');
      rethrow;
    }
  }

  /// Upload media file to Firebase Storage
  Future<String> _uploadMedia(String postId, String filePath) async {
    try {
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final ref = _storage.ref().child('posts/$postId/$fileName');

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      _logger.e('Error uploading media: $e');
      rethrow;
    }
  }

  /// Determine media type from file path
  MediaType _getMediaType(String path) {
    final extension = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return MediaType.image;
    } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
      return MediaType.video;
    }
    return MediaType.voice;
  }

  /// Like a post
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final postRef = _firestore.collection('posts').doc(postId);
        final doc = await transaction.get(postRef);

        if (!doc.exists) {
          throw Exception('Post not found');
        }

        final post = PostModel.fromFirestore(doc);
        final likedBy = List<String>.from(post.likedBy);

        if (!likedBy.contains(userId)) {
          likedBy.add(userId);
          transaction.update(postRef, {
            'likes': post.likes + 1,
            'likedBy': likedBy,
          });
        }
      });
    } catch (e) {
      _logger.e('Error liking post: $e');
      rethrow;
    }
  }

  /// Unlike a post
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final postRef = _firestore.collection('posts').doc(postId);
        final doc = await transaction.get(postRef);

        if (!doc.exists) {
          throw Exception('Post not found');
        }

        final post = PostModel.fromFirestore(doc);
        final likedBy = List<String>.from(post.likedBy);

        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          transaction.update(postRef, {
            'likes': post.likes - 1,
            'likedBy': likedBy,
          });
        }
      });
    } catch (e) {
      _logger.e('Error unliking post: $e');
      rethrow;
    }
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error deleting post: $e');
      rethrow;
    }
  }
}

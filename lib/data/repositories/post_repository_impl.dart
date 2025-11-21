import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/remote/rest_api/posts_api.dart';

class PostRepositoryImpl implements PostRepository {
  final PostsApi _postsApi;

  PostRepositoryImpl({required PostsApi postsApi}) : _postsApi = postsApi;

  @override
  Future<List<Post>> getFeedPosts({
    required String userId,
    int limit = 20,
    String? lastPostId,
    List<String>? followedUserIds,
  }) async {
    // Note: PostsApi uses DocumentSnapshot for cursor-based pagination
    // For now, we ignore lastPostId and fetch from the beginning
    // TODO: Implement proper cursor-based pagination by storing DocumentSnapshot
    return await _postsApi.getFeedPosts(
      userId: userId,
      limit: limit,
      lastDocument: null,
      followedUserIds: followedUserIds ?? const [],
    );
  }

  @override
  Future<Post> getPostById(String postId) async {
    return await _postsApi.getPostById(postId);
  }

  @override
  Future<List<Post>> getPostsByUser({
    required String userId,
    int limit = 20,
    String? lastPostId,
  }) async {
    return await _postsApi.getPostsByUser(
      userId: userId,
      limit: limit,
    );
  }

  @override
  Future<Post> createPost({
    required String userId,
    required String content,
    List<String>? mediaPaths,
    PostVisibility visibility = PostVisibility.public,
  }) async {
    return await _postsApi.createPost(
      userId: userId,
      content: content,
      mediaPaths: mediaPaths,
      visibility: visibility,
    );
  }

  @override
  Future<Post> updatePost({
    required String postId,
    required String content,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(String postId) async {
    await _postsApi.deletePost(postId);
  }

  @override
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    await _postsApi.likePost(postId: postId, userId: userId);
  }

  @override
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    await _postsApi.unlikePost(postId: postId, userId: userId);
  }

  @override
  Future<List<Post>> getLikedPosts({
    required String userId,
    int limit = 20,
    String? lastPostId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Post> sharePost({
    required String postId,
    required String userId,
    String? comment,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getTrendingPosts({
    int limit = 20,
    String? lastPostId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchPosts({
    required String query,
    int limit = 20,
    String? lastPostId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPostsByHashtag({
    required String hashtag,
    int limit = 20,
    String? lastPostId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<PostMetadata> getPostStats(String postId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> reportPost({
    required String postId,
    required String userId,
    required String reason,
  }) async {
    throw UnimplementedError();
  }
}

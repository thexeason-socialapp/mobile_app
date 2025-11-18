import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/repositories/post_repository.dart';
import '../../../../core/di/providers.dart';
import '../../auth/providers/auth_state_provider.dart';

/// Feed State
class FeedState {
  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final String? lastPostId;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.lastPostId,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    String? lastPostId,
    bool clearError = false,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastPostId: lastPostId ?? this.lastPostId,
    );
  }
}

/// Feed State Notifier
class FeedNotifier extends StateNotifier<FeedState> {
  final PostRepository _postRepository;
  final String userId;

  FeedNotifier({
    required PostRepository postRepository,
    required this.userId,
  })  : _postRepository = postRepository,
        super(const FeedState()) {
    loadFeed();
  }

  /// Load initial feed
  Future<void> loadFeed() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final posts = await _postRepository.getFeedPosts(
        userId: userId,
        limit: 20,
      );

      state = state.copyWith(
        posts: posts,
        isLoading: false,
        hasMore: posts.length >= 20,
        lastPostId: posts.isNotEmpty ? posts.last.id : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more posts (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final newPosts = await _postRepository.getFeedPosts(
        userId: userId,
        limit: 20,
        lastPostId: state.lastPostId,
      );

      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoadingMore: false,
        hasMore: newPosts.length >= 20,
        lastPostId: newPosts.isNotEmpty ? newPosts.last.id : state.lastPostId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh feed
  Future<void> refresh() async {
    state = const FeedState();
    await loadFeed();
  }

  /// Update a post in the feed (after like/unlike)
  void updatePost(Post updatedPost) {
    final updatedPosts = state.posts.map((post) {
      return post.id == updatedPost.id ? updatedPost : post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  /// Remove a post from feed (after delete)
  void removePost(String postId) {
    final updatedPosts = state.posts.where((post) => post.id != postId).toList();
    state = state.copyWith(posts: updatedPosts);
  }
}

/// Feed State Provider
final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id ?? '';

  return FeedNotifier(
    postRepository: postRepository,
    userId: userId,
  );
});

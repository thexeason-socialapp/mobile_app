import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/repositories/post_repository.dart';
import '../../../../core/di/providers.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'feed_state_provider.dart';

/// Post Interaction Provider - Handles like/unlike/share actions
class PostInteractionNotifier extends StateNotifier<Map<String, bool>> {
  final PostRepository _postRepository;
  final Ref _ref;

  PostInteractionNotifier({
    required PostRepository postRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _ref = ref,
        super({});

  /// Toggle like on a post
  Future<void> toggleLike(Post post) async {
    final authState = _ref.read(authProvider);
    final userId = authState.user?.id;

    if (userId == null) return;

    final isCurrentlyLiked = post.isLikedBy(userId);
    final postId = post.id;

    // Optimistic update
    state = {...state, postId: !isCurrentlyLiked};

    try {
      if (isCurrentlyLiked) {
        await _postRepository.unlikePost(postId: postId, userId: userId);
      } else {
        await _postRepository.likePost(postId: postId, userId: userId);
      }

      // Update the post in feed
      final updatedLikedBy = List<String>.from(post.likedBy);
      if (isCurrentlyLiked) {
        updatedLikedBy.remove(userId);
      } else {
        updatedLikedBy.add(userId);
      }

      final updatedPost = post.copyWith(
        likes: isCurrentlyLiked ? post.likes - 1 : post.likes + 1,
        likedBy: updatedLikedBy,
      );

      _ref.read(feedProvider.notifier).updatePost(updatedPost);
    } catch (e) {
      // Revert optimistic update on error
      state = {...state, postId: isCurrentlyLiked};
    }
  }

  /// Check if post is liked
  bool isLiked(Post post, String userId) {
    return state[post.id] ?? post.isLikedBy(userId);
  }
}

/// Post Interaction Provider
final postInteractionProvider =
    StateNotifierProvider<PostInteractionNotifier, Map<String, bool>>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);

  return PostInteractionNotifier(
    postRepository: postRepository,
    ref: ref,
  );
});

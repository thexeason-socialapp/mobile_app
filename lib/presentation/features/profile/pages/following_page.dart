import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/widgets/cards/user_card.dart';

/// State for following list
class FollowingState {
  final List<User> following;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String? lastUserId;

  const FollowingState({
    this.following = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastUserId,
  });

  FollowingState copyWith({
    List<User>? following,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? lastUserId,
    bool clearError = false,
  }) {
    return FollowingState(
      following: following ?? this.following,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastUserId: lastUserId ?? this.lastUserId,
    );
  }
}

/// Following notifier
class FollowingNotifier extends StateNotifier<FollowingState> {
  final UserRepository _userRepository;
  final String userId;

  FollowingNotifier({
    required UserRepository userRepository,
    required this.userId,
  })  : _userRepository = userRepository,
        super(const FollowingState()) {
    loadFollowing();
  }

  Future<void> loadFollowing() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final following = await _userRepository.getFollowing(
        userId: userId,
        limit: 20,
        lastUserId: state.lastUserId,
      );

      state = state.copyWith(
        following: [...state.following, ...following],
        isLoading: false,
        hasMore: following.length >= 20,
        lastUserId: following.isNotEmpty ? following.last.id : state.lastUserId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = const FollowingState();
    await loadFollowing();
  }
}

/// Provider for following
final followingProvider = StateNotifierProvider.family<FollowingNotifier, FollowingState, String>(
  (ref, userId) {
    final userRepository = ref.watch(userRepositoryProvider);
    return FollowingNotifier(
      userRepository: userRepository,
      userId: userId,
    );
  },
);

/// Following Page
class FollowingPage extends ConsumerStatefulWidget {
  final String userId;

  const FollowingPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends ConsumerState<FollowingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(followingProvider(widget.userId).notifier).loadFollowing();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(followingProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(followingProvider(widget.userId).notifier).refresh();
        },
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(FollowingState state) {
    if (state.isLoading && state.following.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.following.isEmpty) {
      return _buildErrorState(state.error!);
    }

    if (state.following.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.following.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= state.following.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = state.following[index];
        return UserCard(user: user);
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading following',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(followingProvider(widget.userId).notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Not following anyone yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you follow people,\nthey will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

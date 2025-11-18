import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/widgets/cards/user_card.dart';

/// State for followers list
class FollowersState {
  final List<User> followers;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String? lastUserId;

  const FollowersState({
    this.followers = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastUserId,
  });

  FollowersState copyWith({
    List<User>? followers,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? lastUserId,
    bool clearError = false,
  }) {
    return FollowersState(
      followers: followers ?? this.followers,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastUserId: lastUserId ?? this.lastUserId,
    );
  }
}

/// Followers notifier
class FollowersNotifier extends StateNotifier<FollowersState> {
  final UserRepository _userRepository;
  final String userId;

  FollowersNotifier({
    required UserRepository userRepository,
    required this.userId,
  })  : _userRepository = userRepository,
        super(const FollowersState()) {
    loadFollowers();
  }

  Future<void> loadFollowers() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final followers = await _userRepository.getFollowers(
        userId: userId,
        limit: 20,
        lastUserId: state.lastUserId,
      );

      state = state.copyWith(
        followers: [...state.followers, ...followers],
        isLoading: false,
        hasMore: followers.length >= 20,
        lastUserId: followers.isNotEmpty ? followers.last.id : state.lastUserId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = const FollowersState();
    await loadFollowers();
  }
}

/// Provider for followers
final followersProvider = StateNotifierProvider.family<FollowersNotifier, FollowersState, String>(
  (ref, userId) {
    final userRepository = ref.watch(userRepositoryProvider);
    return FollowersNotifier(
      userRepository: userRepository,
      userId: userId,
    );
  },
);

/// Followers Page
class FollowersPage extends ConsumerStatefulWidget {
  final String userId;

  const FollowersPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends ConsumerState<FollowersPage> {
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
      ref.read(followersProvider(widget.userId).notifier).loadFollowers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(followersProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(followersProvider(widget.userId).notifier).refresh();
        },
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(FollowersState state) {
    if (state.isLoading && state.followers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.followers.isEmpty) {
      return _buildErrorState(state.error!);
    }

    if (state.followers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.followers.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= state.followers.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = state.followers[index];
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
              'Error loading followers',
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
                ref.read(followersProvider(widget.userId).notifier).refresh();
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
            'No followers yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When people follow this account,\nthey will appear here',
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

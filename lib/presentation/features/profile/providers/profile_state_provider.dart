import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../../../core/di/providers.dart' as di;

/// 👤 PROFILE STATE
/// Holds the state for a user profile
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isFollowing;
  final bool isOwnProfile;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isFollowing = false,
    this.isOwnProfile = false,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isFollowing,
    bool? isOwnProfile,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isFollowing: isFollowing ?? this.isFollowing,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
    );
  }
}

/// =d PROFILE STATE NOTIFIER
/// Manages profile state and operations
class ProfileStateNotifier extends StateNotifier<ProfileState> {
  final UserRepository _userRepository;
  final String? _currentUserId;

  ProfileStateNotifier({
    required UserRepository userRepository,
    required String? currentUserId,
  })  : _userRepository = userRepository,
        _currentUserId = currentUserId,
        super(const ProfileState());

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _userRepository.getUserById(userId);
      final isOwnProfile = userId == _currentUserId;

      // Check if current user is following this user (if not own profile)
      bool isFollowing = false;
      if (!isOwnProfile && _currentUserId != null) {
        isFollowing = await _userRepository.isFollowing(
          followerId: _currentUserId,
          followingId: userId,
        );
      }

      state = ProfileState(
        user: user,
        isLoading: false,
        isFollowing: isFollowing,
        isOwnProfile: isOwnProfile,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Follow user
  Future<void> followUser() async {
    final currentUserId = _currentUserId;
    final currentUser = state.user;
    if (currentUserId == null || currentUser == null) return;

    try {
      await _userRepository.followUser(
        followerId: currentUserId,
        followingId: currentUser.id,
      );

      // Update local state optimistically
      state = state.copyWith(
        isFollowing: true,
        user: currentUser.copyWith(
          followers: currentUser.followers + 1,
        ),
      );
    } catch (e) {
      // Revert on error
      state = state.copyWith(error: 'Failed to follow user: $e');
    }
  }

  /// Unfollow user
  Future<void> unfollowUser() async {
    final currentUserId = _currentUserId;
    final currentUser = state.user;
    if (currentUserId == null || currentUser == null) return;

    try {
      await _userRepository.unfollowUser(
        followerId: currentUserId,
        followingId: currentUser.id,
      );

      // Update local state optimistically
      state = state.copyWith(
        isFollowing: false,
        user: currentUser.copyWith(
          followers: currentUser.followers - 1,
        ),
      );
    } catch (e) {
      // Revert on error
      state = state.copyWith(error: 'Failed to unfollow user: $e');
    }
  }

  /// Refresh profile
  Future<void> refresh() async {
    if (state.user != null) {
      await loadProfile(state.user!.id);
    }
  }
}

/// Provider for profile state
final profileStateProvider = StateNotifierProvider.family<ProfileStateNotifier, ProfileState, String>(
  (ref, userId) {
    final userRepository = ref.watch(di.userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    final notifier = ProfileStateNotifier(
      userRepository: userRepository,
      currentUserId: currentUser?.id,
    );

    // Auto-load profile when provider is created
    Future.microtask(() => notifier.loadProfile(userId));

    return notifier;
  },
);

/// Helper provider to check if viewing own profile
final isOwnProfileProvider = Provider.family<bool, String>((ref, userId) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser?.id == userId;
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../providers/profile_state_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/posts_grid.dart';

/// 👤 PROFILE PAGE
/// Displays user profile with responsive layout
/// Supports viewing own profile and other users' profiles
class ProfilePage extends ConsumerStatefulWidget {
  final String userId;

  const ProfilePage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateProvider(widget.userId));

    return Scaffold(
      body: _buildBody(profileState),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading && state.user == null) {
      return _buildLoadingState();
    }

    if (state.error != null && state.user == null) {
      return _buildErrorState(state.error!);
    }

    if (state.user == null) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(profileStateProvider(widget.userId).notifier).refresh();
      },
      child: CustomScrollView(
        slivers: [
          _buildAppBar(state),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  user: state.user!,
                  isOwnProfile: state.isOwnProfile,
                  isFollowing: state.isFollowing,
                  isLoadingFollow: false, // TODO: Add loading state
                  onEditProfile: state.isOwnProfile ? _handleEditProfile : null,
                  onFollowToggle: !state.isOwnProfile ? () => _handleFollowToggle(state) : null,
                ),

                const SizedBox(height: 16),

                // Stats
                Padding(
                  padding: context.responsiveHorizontalPadding,
                  child: ProfileStats(
                    postsCount: state.user!.postsCount,
                    followersCount: state.user!.followers,
                    followingCount: state.user!.following,
                    onFollowersTap: () => _navigateToFollowers(state.user!.id),
                    onFollowingTap: () => _navigateToFollowing(state.user!.id),
                  ),
                ),

                const SizedBox(height: 24),

                // Tabs
                _buildTabs(),
              ],
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsTab(state),
                _buildMediaTab(state),
                _buildLikesTab(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ProfileState state) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      title: Text(state.user?.displayName ?? 'Profile'),
      actions: [
        if (state.isOwnProfile)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _handleSettings,
          )
        else
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, state),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 12),
                    Text('Share Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block),
                    SizedBox(width: 12),
                    Text('Block User'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag),
                    SizedBox(width: 12),
                    Text('Report'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTabs() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
        indicatorColor: theme.colorScheme.primary,
        tabs: const [
          Tab(
            icon: Icon(Icons.grid_on),
            text: 'Posts',
          ),
          Tab(
            icon: Icon(Icons.photo_library),
            text: 'Media',
          ),
          Tab(
            icon: Icon(Icons.favorite_border),
            text: 'Likes',
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab(ProfileState state) {
    if (state.user?.postsCount == 0) {
      return _buildPlaceholder('No posts yet');
    }
    return PostsGrid(
      userId: widget.userId,
      isOwnProfile: state.isOwnProfile,
    );
  }

  Widget _buildMediaTab(ProfileState state) {
    // TODO: Implement media grid
    return _buildPlaceholder('Media will appear here');
  }

  Widget _buildLikesTab(ProfileState state) {
    if (!state.isOwnProfile) {
      return _buildPlaceholder('Likes are private');
    }
    // TODO: Implement likes grid
    return _buildPlaceholder('Liked posts will appear here');
  }

  Widget _buildPlaceholder(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(profileStateProvider(widget.userId).notifier).refresh();
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
    return const Center(
      child: Text('User not found'),
    );
  }

  // Actions
  void _handleEditProfile() {
    context.push('/profile/edit');
  }

  void _handleSettings() {
    context.push('/settings');
  }

  void _handleFollowToggle(ProfileState state) {
    if (state.isFollowing) {
      ref.read(profileStateProvider(widget.userId).notifier).unfollowUser();
    } else {
      ref.read(profileStateProvider(widget.userId).notifier).followUser();
    }
  }

  void _handleMenuAction(String action, ProfileState state) {
    switch (action) {
      case 'share':
        // TODO: Implement share
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share - Coming Soon')),
        );
        break;
      case 'block':
        // TODO: Implement block
        _showBlockDialog(state);
        break;
      case 'report':
        // TODO: Implement report
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report - Coming Soon')),
        );
        break;
    }
  }

  void _showBlockDialog(ProfileState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block @${state.user?.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement block user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
            },
            child: Text(
              'Block',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToFollowers(String userId) {
    context.push('/user/$userId/followers');
  }

  void _navigateToFollowing(String userId) {
    context.push('/user/$userId/following');
  }
}

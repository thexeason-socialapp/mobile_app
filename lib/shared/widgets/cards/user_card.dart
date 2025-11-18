import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user.dart';
import '../../../presentation/features/profile/widgets/avatar_widget.dart';
import '../../../presentation/features/auth/providers/auth_state_provider.dart';
import '../../../core/di/providers.dart';

/// UserCard Widget - Displays user information in a card format
/// Used in followers/following lists, search results, etc.
class UserCard extends ConsumerStatefulWidget {
  final User user;
  final VoidCallback? onTap;
  final bool showFollowButton;
  final bool showBio;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.showFollowButton = true,
    this.showBio = true,
  });

  @override
  ConsumerState<UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<UserCard> {
  bool _isFollowing = false;
  bool _isLoadingFollow = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.id;

    if (currentUserId == null || currentUserId == widget.user.id) {
      return;
    }

    try {
      final userRepository = ref.read(userRepositoryProvider);
      final isFollowing = await userRepository.isFollowing(
        followerId: currentUserId,
        followingId: widget.user.id,
      );

      if (mounted) {
        setState(() {
          _isFollowing = isFollowing;
        });
      }
    } catch (e) {
      // Handle error silently or show a message
    }
  }

  Future<void> _toggleFollow() async {
    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.id;

    if (currentUserId == null) {
      return;
    }

    setState(() {
      _isLoadingFollow = true;
    });

    try {
      final userRepository = ref.read(userRepositoryProvider);

      if (_isFollowing) {
        await userRepository.unfollowUser(
          followerId: currentUserId,
          followingId: widget.user.id,
        );
      } else {
        await userRepository.followUser(
          followerId: currentUserId,
          followingId: widget.user.id,
        );
      }

      if (mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
          _isLoadingFollow = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFollow = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${_isFollowing ? 'unfollow' : 'follow'} user'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;
    final isOwnProfile = currentUserId == widget.user.id;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap ?? () => _navigateToProfile(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              AvatarWidget(
                imageUrl: widget.user.avatar,
                displayName: widget.user.displayName,
                size: 56,
              ),
              const SizedBox(width: 12),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display name with verified badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.user.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.user.verified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 18,
                            color: Color(0xFFFFC107),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Username
                    Text(
                      '@${widget.user.username}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Bio (optional)
                    if (widget.showBio && widget.user.bio != null && widget.user.bio!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.user.bio!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Follower count
                    const SizedBox(height: 4),
                    Text(
                      '${_formatCount(widget.user.followers)} followers',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Follow button
              if (widget.showFollowButton && !isOwnProfile) ...[
                const SizedBox(width: 8),
                _buildFollowButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    if (_isLoadingFollow) {
      return const SizedBox(
        width: 80,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return SizedBox(
      width: 80,
      child: OutlinedButton(
        onPressed: _toggleFollow,
        style: OutlinedButton.styleFrom(
          foregroundColor: _isFollowing ? Colors.grey[700] : const Color(0xFFFFC107),
          backgroundColor: _isFollowing ? Colors.transparent : const Color(0xFFFFC107),
          side: BorderSide(
            color: _isFollowing ? Colors.grey[300]! : const Color(0xFFFFC107),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _isFollowing ? Colors.grey[700] : Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    context.push('/user/${widget.user.id}');
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// Compact version of UserCard for smaller spaces
class UserCardCompact extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCardCompact({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => context.push('/user/${user.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            AvatarWidget(
              imageUrl: user.avatar,
              displayName: user.displayName,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.displayName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.verified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Color(0xFFFFC107),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

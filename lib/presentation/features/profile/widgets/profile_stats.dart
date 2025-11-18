import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/responsive_extensions.dart';

/// =� PROFILE STATS
/// Displays user statistics (posts, followers, following)
/// Responsive layout that adapts to screen size
class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onPostsTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const ProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.onPostsTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          count: postsCount,
          label: 'Posts',
          onTap: onPostsTap,
        ),
        _buildDivider(context),
        _StatItem(
          count: followersCount,
          label: 'Followers',
          onTap: onFollowersTap,
        ),
        _buildDivider(context),
        _StatItem(
          count: followingCount,
          label: 'Following',
          onTap: onFollowingTap,
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: context.isMobile ? 40 : 50,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }
}

/// Individual stat item
class _StatItem extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback? onTap;

  const _StatItem({
    required this.count,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isMobile;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 8 : 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Count
            Text(
              _formatCount(count),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 20 : 24,
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Format large numbers (e.g., 1000 -> 1K, 1000000 -> 1M)
  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      final formatted = (count / 1000).toStringAsFixed(1);
      return formatted.endsWith('.0')
          ? '${(count / 1000).toInt()}K'
          : '${formatted}K';
    } else {
      final formatted = (count / 1000000).toStringAsFixed(1);
      return formatted.endsWith('.0')
          ? '${(count / 1000000).toInt()}M'
          : '${formatted}M';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/user.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../core/utils/responsive_widgets.dart';
import 'avatar_widget.dart';
import 'follow_button.dart';

/// =� PROFILE HEADER
/// Displays user profile header with banner, avatar, and user info
/// Responsive layout that adapts to screen size
class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isOwnProfile;
  final bool isFollowing;
  final bool isLoadingFollow;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onBannerTap;
  final VoidCallback? onEditProfile;
  final VoidCallback? onFollowToggle;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isOwnProfile,
    this.isFollowing = false,
    this.isLoadingFollow = false,
    this.onAvatarTap,
    this.onBannerTap,
    this.onEditProfile,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  /// Mobile layout (vertical, compact)
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildBanner(context, height: 180),
        Transform.translate(
          offset: const Offset(0, -40),
          child: Column(
            children: [
              _buildAvatar(context, size: 80),
              const SizedBox(height: 12),
              _buildUserInfo(context),
              const SizedBox(height: 16),
              _buildActionButton(context),
            ],
          ),
        ),
      ],
    );
  }

  /// Tablet layout (more spacious)
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        _buildBanner(context, height: 220),
        Transform.translate(
          offset: const Offset(0, -50),
          child: Column(
            children: [
              _buildAvatar(context, size: 100),
              const SizedBox(height: 16),
              _buildUserInfo(context),
              const SizedBox(height: 20),
              _buildActionButton(context),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop layout (horizontal info, larger sizes)
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        _buildBanner(context, height: 280),
        Transform.translate(
          offset: const Offset(0, -60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context, size: 120),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildUserInfo(context, isDesktop: true),
                      const SizedBox(height: 20),
                      _buildActionButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Banner image
  Widget _buildBanner(BuildContext context, {required double height}) {
    return GestureDetector(
      onTap: onBannerTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: user.banner != null && user.banner!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: user.banner!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                errorWidget: (context, url, error) => _buildBannerPlaceholder(context),
              )
            : _buildBannerPlaceholder(context),
      ),
    );
  }

  Widget _buildBannerPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Avatar
  Widget _buildAvatar(BuildContext context, {required double size}) {
    return AvatarWidget(
      imageUrl: user.avatar,
      displayName: user.displayName,
      size: size,
      showEditOverlay: isOwnProfile,
      onTap: onAvatarTap,
      onEditTap: onEditProfile,
    );
  }

  /// User info (name, username, bio, etc.)
  Widget _buildUserInfo(BuildContext context, {bool isDesktop = false}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Display name
        Row(
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                user.displayName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: context.isMobile ? 20 : (context.isTablet ? 24 : 28),
                ),
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (user.verified) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.verified,
                color: theme.colorScheme.primary,
                size: context.isMobile ? 20 : 24,
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Username
        Text(
          '@${user.username}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: context.isMobile ? 14 : 16,
          ),
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
        ),

        // Bio
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 600 : double.infinity,
            ),
            child: Text(
              user.bio!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: context.isMobile ? 14 : 15,
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ),
        ],

        // Location and website
        if (user.location != null || user.website != null) ...[
          const SizedBox(height: 12),
          Wrap(
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              if (user.location != null)
                _buildInfoChip(
                  context,
                  Icons.location_on_outlined,
                  user.location!,
                ),
              if (user.website != null)
                _buildInfoChip(
                  context,
                  Icons.link,
                  user.website!,
                  isLink: true,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String text, {
    bool isLink = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isLink ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
              decoration: isLink ? TextDecoration.underline : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Action button (Edit Profile or Follow)
  Widget _buildActionButton(BuildContext context) {
    if (isOwnProfile) {
      return SizedBox(
        width: context.isMobile ? double.infinity : 200,
        child: OutlinedButton.icon(
          onPressed: onEditProfile,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Edit Profile'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    } else {
      return FollowButton(
        isFollowing: isFollowing,
        isLoading: isLoadingFollow,
        onPressed: onFollowToggle ?? () {},
      );
    }
  }
}

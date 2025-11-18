import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// =d AVATAR WIDGET
/// Displays user avatar with optional edit overlay
/// Supports different sizes and tap actions
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String displayName;
  final double size;
  final bool showEditOverlay;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    required this.displayName,
    this.size = 80.0,
    this.showEditOverlay = false,
    this.onTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Avatar circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(primaryColor),
                      errorWidget: (context, url, error) => _buildInitials(primaryColor),
                    )
                  : _buildInitials(primaryColor),
            ),
          ),

          // Edit overlay (if enabled)
          if (showEditOverlay)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: size * 0.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build loading placeholder
  Widget _buildPlaceholder(Color primaryColor) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  /// Build initials fallback
  Widget _buildInitials(Color primaryColor) {
    final initials = _getInitials(displayName);

    return Container(
      color: primaryColor.withOpacity(0.1),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  /// Get initials from display name
  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }
}

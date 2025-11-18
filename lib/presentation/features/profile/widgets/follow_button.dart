import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_extensions.dart';

/// = FOLLOW BUTTON
/// Displays follow/following button with different states
/// Supports responsive sizing
class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isCompact;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
    this.isLoading = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Responsive sizing
    final buttonHeight = isCompact ? 36.0 : (context.isMobile ? 40.0 : 44.0);
    final buttonWidth = isCompact ? 100.0 : (context.isMobile ? 120.0 : 140.0);
    final fontSize = isCompact ? 13.0 : (context.isMobile ? 14.0 : 15.0);

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: isLoading
          ? _buildLoadingButton(theme, buttonHeight)
          : _buildButton(context, theme, fontSize),
    );
  }

  Widget _buildLoadingButton(ThemeData theme, double height) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: height * 0.5,
          height: height * 0.5,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, double fontSize) {
    if (isFollowing) {
      // Following state - outlined button
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? 16 : 20,
            vertical: 8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: fontSize + 2,
            ),
            const SizedBox(width: 6),
            Text(
              'Following',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      // Not following state - filled button
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? 16 : 20,
            vertical: 8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: fontSize + 2,
            ),
            const SizedBox(width: 6),
            Text(
              'Follow',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }
}

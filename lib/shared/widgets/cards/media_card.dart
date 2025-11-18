import 'package:flutter/material.dart';

/// Media Card Widget - For displaying images/videos in a card format
class MediaCard extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Widget? overlay;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const MediaCard({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.onTap,
    this.overlay,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              if (imageUrl != null)
                Image.network(
                  imageUrl!,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              else
                const Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),

              // Overlay (optional)
              if (overlay != null) overlay!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Media Grid Card - Optimized for grid displays
class MediaGridCard extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? badge;

  const MediaGridCard({
    super.key,
    this.imageUrl,
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return MediaCard(
      imageUrl: imageUrl,
      onTap: onTap,
      overlay: badge != null
          ? Positioned(
              top: 8,
              right: 8,
              child: badge!,
            )
          : null,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/config/cloudinary_config.dart';

/// CloudinaryImageWidget
/// Displays images from Cloudinary with automatic transformations and caching
///
/// Features:
/// - Auto-responsive transformations based on device
/// - Smart caching with CachedNetworkImage
/// - Placeholder and error handling
/// - Face detection for avatar crops
/// - Multiple transformation presets
///
/// Example:
/// ```dart
/// CloudinaryImageWidget(
///   imageUrl: 'https://res.cloudinary.com/...',
///   width: 200,
///   height: 200,
///   transformationType: 'avatar',
/// )
/// ```
class CloudinaryImageWidget extends StatelessWidget {
  /// Full Cloudinary URL or public ID
  final String imageUrl;

  /// Widget width (optional, can be limited by parent)
  final double? width;

  /// Widget height (optional, can be limited by parent)
  final double? height;

  /// How to fit the image in the box
  final BoxFit fit;

  /// Optional placeholder while loading (asset path)
  final String? placeholder;

  /// Optional error widget
  final Widget? errorWidget;

  /// Enable network image caching
  final bool enableCache;

  /// Type of transformation to apply
  /// Options: 'avatar', 'avatar_large', 'feed', 'thumbnail', 'banner', 'post_image', 'mobile', 'tablet', 'desktop'
  final String transformationType;

  /// Custom transformations to override default
  /// If provided, transformationType is ignored
  final List<String>? customTransformations;

  /// Custom gravity for cropping (e.g., 'face', 'center')
  final String? gravity;

  /// Border radius for rounded corners
  final BorderRadius? borderRadius;

  /// Shadow effect
  final BoxShadow? shadow;

  /// Opacity/transparency (0.0 to 1.0)
  final double opacity;

  /// Whether to show loading indicator while image loads
  final bool showLoadingIndicator;

  const CloudinaryImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.enableCache = true,
    this.transformationType = 'post_image',
    this.customTransformations,
    this.gravity,
    this.borderRadius,
    this.shadow,
    this.opacity = 1.0,
    this.showLoadingIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Skip transformation for non-Cloudinary URLs
    final isCloudinaryUrl = imageUrl.contains('cloudinary.com') ||
                           imageUrl.contains('res.cloudinary.com');

    if (!isCloudinaryUrl) {
      return _buildPlainImage(context);
    }

    // Build optimized Cloudinary URL
    final optimizedUrl = _buildOptimizedUrl();

    // Create the image widget
    Widget imageWidget = enableCache
        ? CachedNetworkImage(
            imageUrl: optimizedUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: placeholder != null
                ? (context, url) => _buildPlaceholder(context)
                : (context, url) => _buildDefaultPlaceholder(context),
            errorWidget: (context, url, error) =>
                errorWidget ?? _buildErrorWidget(context),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
          )
        : Image.network(
            optimizedUrl,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildLoadingState(context);
            },
            errorBuilder: (context, error, stackTrace) =>
                errorWidget ?? _buildErrorWidget(context),
          );

    // Wrap with opacity if needed
    if (opacity < 1.0) {
      imageWidget = Opacity(opacity: opacity, child: imageWidget);
    }

    // Apply border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Apply shadow if specified
    if (shadow != null) {
      imageWidget = Container(
        decoration: BoxDecoration(
          boxShadow: [shadow!],
          borderRadius: borderRadius,
        ),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Build optimized Cloudinary URL with transformations
  String _buildOptimizedUrl() {
    // Handle custom transformations
    if (customTransformations != null && customTransformations!.isNotEmpty) {
      return _buildCustomUrl(customTransformations!);
    }

    // Get transformation based on type
    final transformation = _getTransformation();

    // Add gravity if specified
    var finalTransformation = transformation;
    if (gravity != null) {
      finalTransformation = '$transformation,g_$gravity';
    }

    // Add size constraints if specified
    if (width != null || height != null) {
      final widthParam = width != null ? 'w_${width!.toInt()}' : '';
      final heightParam = height != null ? 'h_${height!.toInt()}' : '';
      final sizeParams = [widthParam, heightParam]
          .where((p) => p.isNotEmpty)
          .join(',');

      if (sizeParams.isNotEmpty) {
        finalTransformation = '$sizeParams,$finalTransformation';
      }
    }

    return _buildCustomUrl([finalTransformation]);
  }

  /// Get transformation string based on type
  String _getTransformation() {
    switch (transformationType.toLowerCase()) {
      case 'avatar':
        return CloudinaryConfig.avatarTransform;
      case 'avatar_large':
        return CloudinaryConfig.avatarLargeTransform;
      case 'post_image':
        return CloudinaryConfig.postImageTransform;
      case 'thumbnail':
        return CloudinaryConfig.thumbnailTransform;
      case 'feed':
        return CloudinaryConfig.feedImageTransform;
      case 'banner':
        return CloudinaryConfig.bannerTransform;
      case 'mobile':
        return CloudinaryConfig.mobileTransform;
      case 'tablet':
        return CloudinaryConfig.tabletTransform;
      case 'desktop':
        return CloudinaryConfig.desktopTransform;
      default:
        return CloudinaryConfig.postImageTransform;
    }
  }

  /// Build custom URL with provided transformations
  String _buildCustomUrl(List<String> transformations) {
    if (!imageUrl.contains('cloudinary.com') &&
        !imageUrl.contains('res.cloudinary.com')) {
      return imageUrl;
    }

    try {
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments.toList();

      // Find 'upload' segment
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1) {
        return imageUrl; // Not a standard Cloudinary URL
      }

      // Extract public ID and path after upload
      final afterUpload = segments.sublist(uploadIndex + 1);
      final publicIdWithExt = afterUpload.join('/');

      // Remove file extension
      final lastDot = publicIdWithExt.lastIndexOf('.');
      final publicId = lastDot != -1
          ? publicIdWithExt.substring(0, lastDot)
          : publicIdWithExt;

      // Build transformation string
      final transformStr = transformations.isEmpty
          ? ''
          : '${transformations.join(',')}/';

      // Reconstruct URL
      final baseUrl = '${uri.scheme}://${uri.host}';
      return '$baseUrl/image/upload/$transformStr$publicId';
    } catch (e) {
      // If parsing fails, return original URL
      return imageUrl;
    }
  }

  /// Build plain image widget for non-Cloudinary URLs
  Widget _buildPlainImage(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildErrorWidget(context),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Build placeholder widget
  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Image.asset(
          placeholder!,
          fit: fit,
        ),
      );
    }
    return _buildDefaultPlaceholder(context);
  }

  /// Build default placeholder
  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image,
          color: Colors.grey[400],
          size: (width ?? 100) * 0.3,
        ),
      ),
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState(BuildContext context) {
    if (!showLoadingIndicator) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
      );
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: (width ?? 100) * 0.3,
        ),
      ),
    );
  }
}

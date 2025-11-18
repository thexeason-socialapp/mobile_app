import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

/// 🖼️ IMAGE HELPER
/// Utility class for image picking, compression, and validation
/// Handles camera, gallery selection, and file optimization
class ImageHelper {
  final ImagePicker _picker;
  final Logger _logger;

  ImageHelper({
    ImagePicker? picker,
    Logger? logger,
  })  : _picker = picker ?? ImagePicker(),
        _logger = logger ?? Logger();

  // ========================================
  // IMAGE PICKING
  // ========================================

  /// Pick image from camera
  Future<File?> pickFromCamera({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) {
        _logger.i('User cancelled camera capture');
        return null;
      }

      return File(image.path);
    } catch (e) {
      _logger.e('Error picking image from camera: $e');
      rethrow;
    }
  }

  /// Pick image from gallery
  Future<File?> pickFromGallery({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) {
        _logger.i('User cancelled gallery selection');
        return null;
      }

      return File(image.path);
    } catch (e) {
      _logger.e('Error picking image from gallery: $e');
      rethrow;
    }
  }

  /// Pick image with source choice
  Future<File?> pickImage({
    required ImageSource source,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    if (source == ImageSource.camera) {
      return pickFromCamera(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
    } else {
      return pickFromGallery(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    int? limit,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (images.isEmpty) {
        _logger.i('User cancelled multiple image selection');
        return [];
      }

      // Apply limit if specified
      final selectedImages = limit != null && images.length > limit
          ? images.sublist(0, limit)
          : images;

      return selectedImages.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      _logger.e('Error picking multiple images: $e');
      rethrow;
    }
  }

  // ========================================
  // IMAGE COMPRESSION
  // ========================================

  /// Compress image file
  /// Note: This is a placeholder. Image compression is handled by ImagePicker quality parameter
  Future<File> compressImage(
    File file, {
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1920,
  }) async {
    try {
      _logger.i('Image already compressed via ImagePicker quality parameter');

      // The image was already compressed when picked via ImagePicker's imageQuality parameter
      // For additional compression, consider using flutter_image_compress package

      return file;
    } catch (e) {
      _logger.e('Error in compression: $e');
      rethrow;
    }
  }

  /// Compress image for avatar (square, smaller size)
  Future<File> compressForAvatar(File file) async {
    return compressImage(
      file,
      quality: 90,
      maxWidth: 512,
      maxHeight: 512,
    );
  }

  /// Compress image for banner (wide, larger size)
  Future<File> compressForBanner(File file) async {
    return compressImage(
      file,
      quality: 85,
      maxWidth: 1920,
      maxHeight: 1080,
    );
  }

  /// Compress image for post (balanced quality/size)
  Future<File> compressForPost(File file) async {
    return compressImage(
      file,
      quality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
  }

  // ========================================
  // IMAGE VALIDATION
  // ========================================

  /// Validate if file is a valid image
  bool isValidImage(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(ext);
  }

  /// Get file size in bytes
  Future<int> getFileSize(File file) async {
    try {
      return await file.length();
    } catch (e) {
      _logger.e('Error getting file size: $e');
      return 0;
    }
  }

  /// Check if file size is under limit
  Future<bool> isUnderSizeLimit(File file, int maxSizeInMB) async {
    final sizeInBytes = await getFileSize(file);
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return sizeInBytes <= maxSizeInBytes;
  }

  /// Validate image file
  Future<ImageValidation> validateImage(
    File file, {
    int maxSizeInMB = 10,
  }) async {
    // Check if file exists
    if (!await file.exists()) {
      return ImageValidation(
        isValid: false,
        error: 'File does not exist',
      );
    }

    // Check file extension
    if (!isValidImage(file)) {
      return ImageValidation(
        isValid: false,
        error: 'Invalid image format. Supported: JPG, PNG, WebP, HEIC',
      );
    }

    // Check file size
    final isUnderLimit = await isUnderSizeLimit(file, maxSizeInMB);
    if (!isUnderLimit) {
      final fileSize = await getFileSize(file);
      return ImageValidation(
        isValid: false,
        error: 'Image too large. Max size: ${maxSizeInMB}MB, Current: ${_formatBytes(fileSize)}',
      );
    }

    // All validations passed
    return ImageValidation(isValid: true);
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Format bytes to human-readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Delete image file
  Future<bool> deleteImage(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _logger.i('Deleted image: ${file.path}');
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Error deleting image: $e');
      return false;
    }
  }

  /// Get image dimensions (returns null on error)
  Future<ImageDimensions?> getImageDimensions(File file) async {
    try {
      if (!kIsWeb) {
        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        final image = frame.image;

        return ImageDimensions(
          width: image.width,
          height: image.height,
        );
      }
      return null;
    } catch (e) {
      _logger.e('Error getting image dimensions: $e');
      return null;
    }
  }
}

// ========================================
// DATA CLASSES
// ========================================

/// Image validation result
class ImageValidation {
  final bool isValid;
  final String? error;

  ImageValidation({
    required this.isValid,
    this.error,
  });
}

/// Image dimensions
class ImageDimensions {
  final int width;
  final int height;

  ImageDimensions({
    required this.width,
    required this.height,
  });

  double get aspectRatio => width / height;

  bool get isLandscape => width > height;
  bool get isPortrait => height > width;
  bool get isSquare => width == height;

  @override
  String toString() => '${width}x$height';
}

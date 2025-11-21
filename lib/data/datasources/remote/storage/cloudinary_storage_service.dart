import 'dart:collection';
import 'dart:convert' show utf8, jsonDecode;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';
import '../../../core/config/cloudinary_config.dart';
import 'storage_service.dart';

/// Cloudinary Storage Service Implementation
/// Uses HTTP API directly for maximum compatibility and control
/// Supports images, videos, audio, and all file types
/// Works across Web, iOS, Android, and Desktop platforms
class CloudinaryStorageService implements StorageService {
  final String _cloudName;
  final String _apiKey;
  final String _apiSecret;
  final Logger _logger;

  static const String _uploadUrl = 'https://api.cloudinary.com/v1_1';
  static const Duration _uploadTimeout = Duration(minutes: 5);

  CloudinaryStorageService({
    required String cloudName,
    required String apiKey,
    required String apiSecret,
    required Logger logger,
  })  : _cloudName = cloudName,
        _apiKey = apiKey,
        _apiSecret = apiSecret,
        _logger = logger;

  @override
  Future<UploadResult> uploadFile({
    required dynamic file, // File on native platforms, dynamic on web
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  }) async {
    try {
      _logger.d('Uploading file to Cloudinary: $path');
      _logger.d('Platform: ${kIsWeb ? 'Web' : 'Mobile/Desktop'}');

      // Extract folder and filename from path
      final pathParts = path.split('/');
      final filename = pathParts.isNotEmpty ? pathParts.last : 'file';
      final folder = pathParts.length > 1
          ? pathParts.sublist(0, pathParts.length - 1).join('/')
          : null;

      // Determine resource type
      final resourceType = _getResourceType(mediaType);

      // Read file bytes - works on both web and native
      late List<int> fileBytes;
      late int fileSize;

      try {
        fileBytes = await file.readAsBytes();
        fileSize = fileBytes.length;
        _logger.d('Successfully read file bytes: $fileSize bytes');
      } catch (e) {
        _logger.e('Error reading file bytes: $e');
        _logger.d('File type: ${file.runtimeType}');
        rethrow;
      }

      _logger.d('File size: $fileSize bytes');
      _logger.d('Resource type: $resourceType');

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_uploadUrl/$_cloudName/$resourceType/upload'),
      );

      // Add file with bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: filename,
        ),
      );

      // Add parameters
      request.fields['api_key'] = _apiKey;
      request.fields['folder'] = folder ?? 'uploads';
      request.fields['public_id'] = _extractPublicId(filename);
      request.fields['overwrite'] = 'true';

      // Generate signature for authenticated upload
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      request.fields['timestamp'] = timestamp;

      final signature = _generateSignature({
        'public_id': _extractPublicId(filename),
        'folder': folder ?? 'uploads',
        'overwrite': 'true',
        'timestamp': timestamp,
      });
      request.fields['signature'] = signature;

      _logger.d('Sending multipart request to Cloudinary...');

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        _uploadTimeout,
        onTimeout: () => throw Exception('Upload timeout after ${_uploadTimeout.inMinutes} minutes'),
      );

      final response = await http.Response.fromStream(streamedResponse);

      _logger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        _logger.i('File uploaded successfully to Cloudinary');

        // Parse JSON response
        try {
          final Map<String, dynamic> responseJson = jsonDecode(response.body);
          final secureUrl = responseJson['secure_url'] as String?;

          if (secureUrl != null && secureUrl.isNotEmpty) {
            _logger.i('Upload URL: $secureUrl');
            return UploadResult(
              url: secureUrl,
              path: folder != null ? '$folder/${_extractPublicId(filename)}' : _extractPublicId(filename),
              size: fileSize,
              mimeType: _getMimeType(mediaType),
              uploadedAt: DateTime.now(),
            );
          } else {
            _logger.e('No secure_url in response: ${response.body}');
            throw Exception('No secure_url returned from Cloudinary');
          }
        } catch (e) {
          _logger.e('Error parsing Cloudinary response: $e');
          _logger.d('Response body: ${response.body}');
          rethrow;
        }
      }

      _logger.e('Upload failed with status ${response.statusCode}');
      throw Exception('Cloudinary upload failed: ${response.statusCode} - ${response.body}');
    } catch (e) {
      _logger.e('Error uploading file to Cloudinary: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      _logger.d('Deleting file from Cloudinary: $path');

      // Extract public ID
      final publicId = _extractPublicId(path);

      // Generate timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Generate signature
      final signature = _generateSignature(
        {'public_id': publicId, 'timestamp': timestamp.toString()},
      );

      // Send delete request
      final response = await http.post(
        Uri.parse('$_uploadUrl/$_cloudName/resources/image/destroy'),
        body: {
          'public_id': publicId,
          'api_key': _apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        _logger.i('File deleted successfully from Cloudinary: $publicId');
      } else {
        _logger.w('Cloudinary delete returned status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error deleting file from Cloudinary: $e');
      rethrow;
    }
  }

  @override
  String getPublicUrl(String path) {
    // If it's already a full Cloudinary URL, return it
    if (path.startsWith('http')) {
      return path;
    }

    // Otherwise, construct the URL from public ID
    return 'https://res.cloudinary.com/$_cloudName/image/upload/$path';
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      // For Cloudinary, we assume the file exists if it was uploaded successfully
      // A proper implementation would require authenticated admin API access
      _logger.w('File existence check not fully implemented for Cloudinary');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get Cloudinary-specific URL with transformations
  String getTransformedUrl(
    String url, {
    int? width,
    int? height,
    String? crop,
    String? gravity,
    String? quality,
    String? format,
  }) {
    final publicId = _extractPublicId(url);

    // Build transformation string
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (crop != null) transformations.add('c_$crop');
    if (gravity != null) transformations.add('g_$gravity');
    if (quality != null) transformations.add('q_$quality');
    if (format != null) transformations.add('f_$format');

    final transformStr = transformations.isEmpty ? '' : '${transformations.join(',')}/';

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformStr$publicId';
  }

  /// Get thumbnail URL (optimized for social media)
  String getThumbnailUrl(String url, {int size = 200}) {
    return getTransformedUrl(
      url,
      width: size,
      height: size,
      crop: 'thumb',
      gravity: 'face',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get optimized avatar URL with face detection
  String getAvatarUrl(String url, {int size = 150}) {
    return getTransformedUrl(
      url,
      width: size,
      height: size,
      crop: 'fill',
      gravity: 'face_center',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get responsive URL (auto-optimized)
  String getResponsiveUrl(String url, {int? maxWidth}) {
    return getTransformedUrl(
      url,
      width: maxWidth,
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get optimized URL for feed display
  String getFeedImageUrl(String url, {bool isThumbnail = false}) {
    if (isThumbnail) {
      return getTransformedUrl(
        url,
        width: 400,
        height: 400,
        crop: 'fill',
        quality: 'auto',
        format: 'auto',
      );
    }
    return getTransformedUrl(
      url,
      width: 1000,
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Extract public ID from Cloudinary URL or path
  String _extractPublicId(String urlOrPath) {
    if (!urlOrPath.startsWith('http')) {
      // Remove file extension
      final lastDot = urlOrPath.lastIndexOf('.');
      return lastDot != -1 ? urlOrPath.substring(0, lastDot) : urlOrPath;
    }

    // Extract public ID from URL
    try {
      final uri = Uri.parse(urlOrPath);
      final segments = uri.pathSegments;

      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < segments.length - 1) {
        final afterUpload = segments.sublist(uploadIndex + 1);
        final startIndex = afterUpload.first.startsWith('v') ? 1 : 0;
        final publicIdSegments = afterUpload.sublist(startIndex);

        final publicIdWithExt = publicIdSegments.join('/');
        final lastDot = publicIdWithExt.lastIndexOf('.');
        return lastDot != -1
            ? publicIdWithExt.substring(0, lastDot)
            : publicIdWithExt;
      }
    } catch (e) {
      _logger.w('Error extracting public ID: $e');
    }

    return urlOrPath;
  }

  /// Get Cloudinary resource type from MediaType
  String _getResourceType(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.image:
        return 'image';
      case MediaType.video:
        return 'video';
      case MediaType.audio:
        return 'video';
      case MediaType.document:
        return 'raw';
    }
  }

  /// Get MIME type from MediaType
  String _getMimeType(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.image:
        return 'image/jpeg';
      case MediaType.video:
        return 'video/mp4';
      case MediaType.audio:
        return 'audio/mpeg';
      case MediaType.document:
        return 'application/octet-stream';
    }
  }

  /// Generate SHA-1 signature for authenticated requests
  String _generateSignature(Map<String, String> params) {
    final sortedParams = SplayTreeMap<String, String>.from(params);
    final paramsString = sortedParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final signatureString = '$paramsString$_apiSecret';
    return sha1.convert(utf8.encode(signatureString)).toString();
  }

  // ============================================================================
  // TRANSFORMATION HELPERS - Advanced Image Optimization
  // ============================================================================

  /// Get optimized avatar URL with face detection
  /// Automatically crops to face center and optimizes for profile display
  String getOptimizedAvatarUrl(String url, {int size = 200}) {
    return getTransformedUrl(
      url,
      width: size,
      height: size,
      crop: 'fill',
      gravity: 'face',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get optimized banner/cover image URL
  /// Maintains aspect ratio and optimizes for header display
  String getOptimizedBannerUrl(String url) {
    return getTransformedUrl(
      url,
      width: 1200,
      height: 400,
      crop: 'limit',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get optimized feed image URL
  /// Perfect for social media feed display
  String getOptimizedFeedUrl(String url) {
    return getTransformedUrl(
      url,
      width: 600,
      crop: 'limit',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get mobile-optimized URL for responsive images
  /// Optimized for mobile devices with smaller file sizes
  String getMobileOptimizedUrl(String url) {
    return getTransformedUrl(
      url,
      width: 480,
      crop: 'limit',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get tablet-optimized URL for responsive images
  /// Optimized for tablet devices
  String getTabletOptimizedUrl(String url) {
    return getTransformedUrl(
      url,
      width: 768,
      crop: 'limit',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get desktop-optimized URL for responsive images
  /// High-quality version for desktop displays
  String getDesktopOptimizedUrl(String url) {
    return getTransformedUrl(
      url,
      width: 1920,
      crop: 'limit',
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Generate multiple optimized URLs for responsive images
  /// Returns a map with device-specific URLs
  Map<String, String> getResponsiveImageUrls(String url) {
    return {
      'mobile': getMobileOptimizedUrl(url),
      'tablet': getTabletOptimizedUrl(url),
      'desktop': getDesktopOptimizedUrl(url),
      'original': url,
    };
  }

  /// Get video thumbnail URL from video
  /// Extracts first frame or specified time as thumbnail
  String getVideoThumbnailUrl(
    String videoUrl, {
    int width = 400,
    int height = 225,
    double timeOffset = 0,
  }) {
    final publicId = _extractPublicId(videoUrl);

    // Build transformation for video thumbnail
    final transformations = <String>[
      'c_fill',
      'w_$width',
      'h_$height',
      'q_auto',
      'f_auto',
    ];

    if (timeOffset > 0) {
      transformations.add('so_${(timeOffset * 1000).toInt()}'); // time in milliseconds
    }

    final transformStr = transformations.join(',');

    return 'https://res.cloudinary.com/$_cloudName/video/upload/$transformStr/$publicId';
  }

  /// Build custom transformation URL
  /// Allows complete control over transformations
  String buildCustomUrl(
    String url, {
    required List<String> transformations,
  }) {
    final publicId = _extractPublicId(url);
    final transformStr = transformations.isEmpty
        ? ''
        : '${transformations.join(',')}/';

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformStr$publicId';
  }

  /// Get delivery optimization URL with explicit settings
  /// More control than getTransformedUrl for advanced use cases
  String getOptimizedUrl(
    String url, {
    int? width,
    int? height,
    String? crop,
    String? gravity,
    String? quality,
    String? format,
    String? radius,
    String? angle,
    String? border,
    String? backgroundColor,
    List<String>? effects,
  }) {
    final publicId = _extractPublicId(url);
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (crop != null) transformations.add('c_$crop');
    if (gravity != null) transformations.add('g_$gravity');
    if (quality != null) transformations.add('q_$quality');
    if (format != null) transformations.add('f_$format');
    if (radius != null) transformations.add('r_$radius');
    if (angle != null) transformations.add('a_$angle');
    if (border != null) transformations.add('b_$border');
    if (backgroundColor != null) transformations.add('b_$backgroundColor');
    if (effects != null && effects.isNotEmpty) {
      transformations.addAll(effects);
    }

    final transformStr = transformations.isEmpty ? '' : '${transformations.join(',')}/';

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformStr$publicId';
  }
}

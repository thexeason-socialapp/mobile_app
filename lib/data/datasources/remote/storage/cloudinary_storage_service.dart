import 'dart:io';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';
import 'storage_service.dart';

/// Cloudinary Storage Service Implementation
/// Supports images, videos, audio, and all file types
/// Provides automatic optimization and transformations
class CloudinaryStorageService implements StorageService {
  final String _cloudName;
  final String _apiKey;
  final String _apiSecret;
  final Logger _logger;

  static const String _uploadUrl = 'https://api.cloudinary.com/v1_1';

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
    required File file,
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  }) async {
    try {
      _logger.d('Uploading file to Cloudinary: $path');

      // Extract folder and filename from path
      final pathParts = path.split('/');
      final filename = pathParts.isNotEmpty ? pathParts.last : 'file';
      final folder = pathParts.length > 1
          ? pathParts.sublist(0, pathParts.length - 1).join('/')
          : null;

      // Determine resource type
      final resourceType = _getResourceType(mediaType);

      // Get file size for progress tracking
      final fileSize = await file.length();

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_uploadUrl/$_cloudName/$resourceType/upload'),
      );

      // Add file
      request.files.add(
        http.MultipartFile(
          'file',
          file.openRead(),
          fileSize,
          filename: filename,
        ),
      );

      // Add parameters
      request.fields['api_key'] = _apiKey;
      request.fields['folder'] = folder ?? 'uploads';
      request.fields['public_id'] = _extractPublicId(filename);
      request.fields['overwrite'] = 'true';

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseJson = response.body;
        _logger.i('File uploaded successfully to Cloudinary');

        // Extract secure URL from response
        // Response format: {"secure_url": "https://...", "public_id": "...", ...}
        final startIndex = responseJson.indexOf('"secure_url":"');
        if (startIndex != -1) {
          final urlStart = startIndex + 14;
          final urlEnd = responseJson.indexOf('"', urlStart);
          final secureUrl = responseJson.substring(urlStart, urlEnd);

          return UploadResult(
            url: secureUrl,
            path: folder != null ? '$folder/${_extractPublicId(filename)}' : _extractPublicId(filename),
            size: fileSize,
            mimeType: _getMimeType(mediaType),
            uploadedAt: DateTime.now(),
          );
        }
      }

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
  /// This is a helper method for creating optimized URLs
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
  /// Perfect for profile pictures and post thumbnails
  String getThumbnailUrl(String url, {int size = 200}) {
    return getTransformedUrl(
      url,
      width: size,
      height: size,
      crop: 'thumb',
      gravity: 'face', // Smart crop focusing on faces
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
      gravity: 'face_center', // Center on face
      quality: 'auto',
      format: 'auto',
    );
  }

  /// Get responsive URL (auto-optimized for different screen sizes)
  String getResponsiveUrl(String url, {int? maxWidth}) {
    return getTransformedUrl(
      url,
      width: maxWidth,
      quality: 'auto',
      format: 'auto', // Automatically serves WebP, AVIF, etc.
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
    // Example: https://res.cloudinary.com/demo/image/upload/v1234/folder/image.jpg
    // Public ID: folder/image
    try {
      final uri = Uri.parse(urlOrPath);
      final segments = uri.pathSegments;

      // Find 'upload' segment and take everything after version number
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < segments.length - 1) {
        final afterUpload = segments.sublist(uploadIndex + 1);

        // Skip version number (starts with 'v')
        final startIndex = afterUpload.first.startsWith('v') ? 1 : 0;
        final publicIdSegments = afterUpload.sublist(startIndex);

        // Join segments and remove extension
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
        return 'video'; // Audio treated as video in Cloudinary
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
    return sha1.convert(signatureString.codeUnits.toList()).toString();
  }
}

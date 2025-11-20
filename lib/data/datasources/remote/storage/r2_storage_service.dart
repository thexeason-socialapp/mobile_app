import 'dart:io';
import 'package:minio/minio.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path_helper;
import 'package:logger/logger.dart';
import 'storage_service.dart';

/// Cloudflare R2 Storage Service Implementation
/// Uses S3-compatible API via Minio client
class R2StorageService implements StorageService {
  final Minio _client;
  final String _bucketName;
  final String _publicUrl;
  final Logger _logger;

  R2StorageService({
    required String endpoint,
    required String accessKey,
    required String secretKey,
    required String bucketName,
    required String publicUrl,
    required Logger logger,
  })  : _bucketName = bucketName,
        _publicUrl = publicUrl,
        _logger = logger,
        _client = Minio(
          endPoint: endpoint.replaceAll('https://', '').replaceAll('http://', ''),
          accessKey: accessKey,
          secretKey: secretKey,
          useSSL: true,
        );

  @override
  Future<UploadResult> uploadFile({
    required dynamic file, // File on native platforms, dynamic on web
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  }) async {
    try {
      _logger.d('Uploading file to R2: $path');

      // Cast to File (works on native platforms)
      final ioFile = file as File;

      // Get file info
      final fileSize = await ioFile.length();
      final mimeType = lookupMimeType(ioFile.path) ?? _getDefaultMimeType(mediaType);

      // Generate unique filename if needed
      final fileName = path_helper.basename(ioFile.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniquePath = path.endsWith(fileName)
          ? path
          : '$path/${timestamp}_$fileName';

      // Upload to R2
      final fileBytes = await ioFile.readAsBytes();
      final fileStream = Stream.value(fileBytes);
      await _client.putObject(
        _bucketName,
        uniquePath,
        fileStream,
      );

      _logger.i('File uploaded successfully to R2: $uniquePath');

      // Return upload result
      final publicUrl = getPublicUrl(uniquePath);
      return UploadResult(
        url: publicUrl,
        path: uniquePath,
        size: fileSize,
        mimeType: mimeType,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error uploading file to R2: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      _logger.d('Deleting file from R2: $path');

      // Extract path from URL if full URL is provided
      final filePath = path.startsWith('http')
          ? path.split('$_publicUrl/').last
          : path;

      await _client.removeObject(_bucketName, filePath);
      _logger.i('File deleted successfully from R2: $filePath');
    } catch (e) {
      _logger.e('Error deleting file from R2: $e');
      rethrow;
    }
  }

  @override
  String getPublicUrl(String path) {
    // Remove leading slash if present
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$_publicUrl/$cleanPath';
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final filePath = path.startsWith('http')
          ? path.split('$_publicUrl/').last
          : path;

      await _client.statObject(_bucketName, filePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get default MIME type based on media type
  String _getDefaultMimeType(MediaType mediaType) {
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
}

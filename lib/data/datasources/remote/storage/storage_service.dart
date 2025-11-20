import 'dart:io';

/// Abstract Storage Service Interface
/// Allows swapping between different storage providers (Firebase, R2, etc.)
abstract class StorageService {
  /// Upload a file to storage
  /// Returns the public URL of the uploaded file
  Future<UploadResult> uploadFile({
    required File file,
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  });

  /// Delete a file from storage
  Future<void> deleteFile(String path);

  /// Get public URL for a file
  String getPublicUrl(String path);

  /// Check if file exists
  Future<bool> fileExists(String path);
}

/// Types of media that can be uploaded
enum MediaType {
  image,
  video,
  audio,
  document,
}

/// Result of a file upload operation
class UploadResult {
  final String url;
  final String path;
  final int size;
  final String mimeType;
  final DateTime uploadedAt;

  const UploadResult({
    required this.url,
    required this.path,
    required this.size,
    required this.mimeType,
    required this.uploadedAt,
  });

  @override
  String toString() =>
      'UploadResult(url: $url, path: $path, size: $size, mimeType: $mimeType)';
}

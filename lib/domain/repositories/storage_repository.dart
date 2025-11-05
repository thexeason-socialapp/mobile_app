/// 📦 STORAGE REPOSITORY INTERFACE
/// Abstract contract defining media storage operations
/// Implementation will be in the data layer (Cloudinary or Firebase Storage)
/// No dependencies on external packages

enum StorageFolder {
  avatars,
  banners,
  posts,
  videos,
  voice,
  messages,
}

class UploadProgress {
  final int bytesTransferred;
  final int totalBytes;
  final double percentage;

  const UploadProgress({
    required this.bytesTransferred,
    required this.totalBytes,
    required this.percentage,
  });
}

abstract class StorageRepository {
  /// Upload an image file
  /// Compresses and optimizes before upload
  /// Returns the public URL of the uploaded image
  Future<String> uploadImage({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
    int? maxWidth,
    int? quality,
  });

  /// Upload a video file
  /// Compresses video before upload
  /// Returns the public URL of the uploaded video
  Future<String> uploadVideo({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
    Function(UploadProgress)? onProgress,
  });

  /// Upload a voice note
  /// Compresses audio before upload
  /// Returns the public URL of the uploaded audio
  Future<String> uploadVoiceNote({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
  });

  /// Upload multiple images at once
  /// Returns list of public URLs
  Future<List<String>> uploadMultipleImages({
    required List<String> filePaths,
    required StorageFolder folder,
    int? maxWidth,
    int? quality,
  });

  /// Delete a file from storage
  /// Removes the file permanently
  Future<void> deleteFile(String fileUrl);

  /// Delete multiple files at once
  Future<void> deleteMultipleFiles(List<String> fileUrls);

  /// Get download URL for a file
  /// Returns the public URL (may be cached)
  Future<String> getDownloadUrl(String filePath);

  /// Compress image before upload
  /// Returns path to compressed image
  Future<String> compressImage({
    required String filePath,
    int maxWidth = 1920,
    int quality = 85,
  });

  /// Compress video before upload
  /// Returns path to compressed video
  Future<String> compressVideo({
    required String filePath,
    int? targetBitrate,
    Function(double)? onProgress,
  });

  /// Generate thumbnail from video
  /// Returns path to generated thumbnail image
  Future<String> generateVideoThumbnail(String videoPath);

  /// Get file size in bytes
  /// Useful for validation before upload
  Future<int> getFileSize(String filePath);

  /// Validate file before upload
  /// Checks file size, format, and dimensions
  /// Throws exception if validation fails
  Future<void> validateFile({
    required String filePath,
    int? maxSizeInMB,
    List<String>? allowedFormats,
  });
}
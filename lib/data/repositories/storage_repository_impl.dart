import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_helper;
import '../../domain/repositories/storage_repository.dart';
import '../datasources/remote/storage/storage_service.dart';

/// Implementation of StorageRepository
/// Handles file compression, validation, and delegates upload to StorageService
class StorageRepositoryImpl implements StorageRepository {
  final StorageService _storageService;
  final Logger _logger;

  StorageRepositoryImpl({
    required StorageService storageService,
    required Logger logger,
  })  : _storageService = storageService,
        _logger = logger;

  @override
  Future<String> uploadImage({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
    int? maxWidth,
    int? quality,
  }) async {
    try {
      // Compress image first
      final compressedPath = await compressImage(
        filePath: filePath,
        maxWidth: maxWidth ?? 1920,
        quality: quality ?? 85,
      );

      // Upload compressed image
      // On web, filePath is already a path string from image_picker
      // On native, create File object
      final file = kIsWeb ? compressedPath : File(compressedPath);
      final storagePath = '${_getFolderPath(folder)}/$fileName';

      final result = await _storageService.uploadFile(
        file: file,
        path: storagePath,
        mediaType: MediaType.image,
      );

      // Clean up compressed file if different from original (native only)
      if (!kIsWeb && compressedPath != filePath) {
        await File(compressedPath).delete();
      }

      return result.url;
    } catch (e) {
      _logger.e('Error uploading image: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadVideo({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
    Function(UploadProgress)? onProgress,
  }) async {
    try {
      // On web, filePath is a path string; on native, create File object
      final file = kIsWeb ? filePath : File(filePath);
      final storagePath = '${_getFolderPath(folder)}/$fileName';

      final result = await _storageService.uploadFile(
        file: file,
        path: storagePath,
        mediaType: MediaType.video,
        onProgress: onProgress != null
            ? (progress) {
                // Only call lengthSync on native File objects
                if (!kIsWeb && file is File) {
                  final fileSize = file.lengthSync();
                  onProgress(UploadProgress(
                    bytesTransferred: (fileSize * progress).toInt(),
                    totalBytes: fileSize,
                    percentage: progress * 100,
                  ));
                }
              }
            : null,
      );

      return result.url;
    } catch (e) {
      _logger.e('Error uploading video: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadVoiceNote({
    required String filePath,
    required StorageFolder folder,
    required String fileName,
  }) async {
    try {
      // On web, filePath is a path string; on native, create File object
      final file = kIsWeb ? filePath : File(filePath);
      final storagePath = '${_getFolderPath(folder)}/$fileName';

      final result = await _storageService.uploadFile(
        file: file,
        path: storagePath,
        mediaType: MediaType.audio,
      );

      return result.url;
    } catch (e) {
      _logger.e('Error uploading voice note: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> uploadMultipleImages({
    required List<String> filePaths,
    required StorageFolder folder,
    int? maxWidth,
    int? quality,
  }) async {
    final urls = <String>[];

    for (var i = 0; i < filePaths.length; i++) {
      final filePath = filePaths[i];
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_image_$i.jpg';

      final url = await uploadImage(
        filePath: filePath,
        folder: folder,
        fileName: fileName,
        maxWidth: maxWidth,
        quality: quality,
      );

      urls.add(url);
    }

    return urls;
  }

  @override
  Future<void> deleteFile(String fileUrl) async {
    try {
      await _storageService.deleteFile(fileUrl);
    } catch (e) {
      _logger.e('Error deleting file: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMultipleFiles(List<String> fileUrls) async {
    for (final url in fileUrls) {
      await deleteFile(url);
    }
  }

  @override
  Future<String> getDownloadUrl(String filePath) async {
    try {
      return _storageService.getPublicUrl(filePath);
    } catch (e) {
      _logger.e('Error getting download URL: $e');
      rethrow;
    }
  }

  @override
  Future<String> compressImage({
    required String filePath,
    int maxWidth = 1920,
    int quality = 85,
  }) async {
    try {
      // Skip compression on web - handled by browser
      if (kIsWeb) {
        _logger.d('Web platform: Skipping image compression (browser handles it)');
        return filePath;
      }

      final file = File(filePath);

      // Try to get temp directory, fallback to app docs directory if it fails
      late String tempPath;
      try {
        final tempDir = await getTemporaryDirectory();
        tempPath = tempDir.path;
      } catch (e) {
        _logger.w('Could not get temp directory, using app docs: $e');
        final appDir = await getApplicationDocumentsDirectory();
        tempPath = appDir.path;
      }

      final targetPath = path_helper.join(
        tempPath,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Compress image (mobile/desktop only)
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: maxWidth,
        minHeight: (maxWidth * 1.5).toInt(), // Maintain aspect ratio
      );

      if (compressedFile == null) {
        _logger.w('Image compression failed, using original file');
        return filePath;
      }

      _logger.d('Image compressed: $filePath -> ${compressedFile.path}');
      return compressedFile.path;
    } catch (e) {
      _logger.e('Error compressing image: $e');
      _logger.w('Using original file due to compression error');
      return filePath; // Return original on error
    }
  }

  @override
  Future<String> compressVideo({
    required String filePath,
    int? targetBitrate,
    Function(double)? onProgress,
  }) async {
    // Video compression is complex and requires native code or external packages
    // For now, return the original file path
    // TODO: Implement video compression using video_compress package
    _logger.w('Video compression not implemented yet');
    return filePath;
  }

  @override
  Future<String> generateVideoThumbnail(String videoPath) async {
    // Video thumbnail generation requires video processing
    // TODO: Implement using video_thumbnail package
    _logger.w('Video thumbnail generation not implemented yet');
    throw UnimplementedError('Video thumbnail generation coming soon');
  }

  @override
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      _logger.e('Error getting file size: $e');
      rethrow;
    }
  }

  @override
  Future<void> validateFile({
    required String filePath,
    int? maxSizeInMB,
    List<String>? allowedFormats,
  }) async {
    final file = File(filePath);

    // Check if file exists
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }

    // Check file size
    if (maxSizeInMB != null) {
      final fileSize = await file.length();
      final maxSizeInBytes = maxSizeInMB * 1024 * 1024;

      if (fileSize > maxSizeInBytes) {
        throw Exception(
          'File size (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB) '
          'exceeds maximum allowed size ($maxSizeInMB MB)',
        );
      }
    }

    // Check file format
    if (allowedFormats != null && allowedFormats.isNotEmpty) {
      final extension = path_helper.extension(filePath).toLowerCase();
      final isAllowed = allowedFormats.any(
        (format) => extension == '.$format' || extension == format,
      );

      if (!isAllowed) {
        throw Exception(
          'File format $extension is not allowed. '
          'Allowed formats: ${allowedFormats.join(', ')}',
        );
      }
    }
  }

  /// Get storage path for a folder
  String _getFolderPath(StorageFolder folder) {
    switch (folder) {
      case StorageFolder.avatars:
        return 'avatars';
      case StorageFolder.banners:
        return 'banners';
      case StorageFolder.posts:
        return 'posts';
      case StorageFolder.videos:
        return 'videos';
      case StorageFolder.voice:
        return 'voice';
      case StorageFolder.messages:
        return 'messages';
    }
  }
}

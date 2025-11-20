import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';
import 'storage_service.dart';

/// Firebase Storage Service Implementation
/// Uses Firebase Storage as the storage backend
class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage;
  final Logger _logger;

  FirebaseStorageService({
    required FirebaseStorage storage,
    required Logger logger,
  })  : _storage = storage,
        _logger = logger;

  @override
  Future<UploadResult> uploadFile({
    required File file,
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  }) async {
    try {
      _logger.d('Uploading file to Firebase Storage: $path');

      // Get file info
      final fileSize = await file.length();
      final mimeType = lookupMimeType(file.path) ?? _getDefaultMimeType(mediaType);

      // Create reference
      final ref = _storage.ref().child(path);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: mimeType,
      );

      // Upload task with progress tracking
      final uploadTask = ref.putFile(file, metadata);

      // Listen to progress if callback provided
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.i('File uploaded successfully to Firebase Storage: $path');

      return UploadResult(
        url: downloadUrl,
        path: path,
        size: fileSize,
        mimeType: mimeType,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error uploading file to Firebase Storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      _logger.d('Deleting file from Firebase Storage: $path');

      // If full URL is provided, extract path
      String filePath = path;
      if (path.startsWith('http')) {
        // Extract path from Firebase Storage URL
        final uri = Uri.parse(path);
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          filePath = pathSegments.last;
        }
      }

      final ref = _storage.ref().child(filePath);
      await ref.delete();

      _logger.i('File deleted successfully from Firebase Storage: $filePath');
    } catch (e) {
      _logger.e('Error deleting file from Firebase Storage: $e');
      rethrow;
    }
  }

  @override
  String getPublicUrl(String path) {
    // For Firebase Storage, we need to actually fetch the download URL
    // This is a placeholder - actual URL is fetched during upload
    return path;
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.getMetadata();
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../core/di/providers.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../domain/repositories/storage_repository.dart';

/// Upload state for a single file upload
class UploadState {
  /// Whether an upload is in progress
  final bool isUploading;

  /// Upload progress (0.0 to 1.0)
  final double progress;

  /// URL of the successfully uploaded file
  final String? uploadedUrl;

  /// Error message if upload failed
  final String? error;

  /// Current file name being uploaded
  final String? currentFileName;

  const UploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.uploadedUrl,
    this.error,
    this.currentFileName,
  });

  /// Copy with method for immutability
  UploadState copyWith({
    bool? isUploading,
    double? progress,
    String? uploadedUrl,
    String? error,
    String? currentFileName,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      error: error ?? this.error,
      currentFileName: currentFileName ?? this.currentFileName,
    );
  }

  @override
  String toString() {
    if (isUploading) {
      return 'Uploading: ${(progress * 100).toStringAsFixed(1)}% - $currentFileName';
    }
    if (error != null) {
      return 'Error: $error';
    }
    if (uploadedUrl != null) {
      return 'Success: $uploadedUrl';
    }
    return 'Ready';
  }
}

/// StateNotifier for managing upload state
class CloudinaryUploadNotifier extends StateNotifier<UploadState> {
  final StorageRepositoryImpl _storageRepository;
  final Logger _logger;

  CloudinaryUploadNotifier(
    this._storageRepository,
    this._logger,
  ) : super(const UploadState());

  /// Upload a single image for posts
  /// Returns the URL of the uploaded image on success, null on failure
  Future<String?> uploadPostImage(
    String filePath, {
    int? maxWidth,
    int? quality,
  }) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
      currentFileName: _getFileName(filePath),
    );

    try {
      _logger.i('Uploading post image: $filePath');

      final fileName =
          'post_${DateTime.now().millisecondsSinceEpoch}_${_getFileName(filePath)}';

      final url = await _storageRepository.uploadImage(
        filePath: filePath,
        folder: StorageFolder.posts,
        fileName: fileName,
        maxWidth: maxWidth ?? 1080,
        quality: quality ?? 85,
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrl: url,
        progress: 1.0,
        error: null,
      );

      _logger.i('Post image uploaded successfully: $url');
      return url;
    } catch (e) {
      final errorMsg = 'Failed to upload post image: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return null;
    }
  }

  /// Upload multiple images for gallery posts
  /// Returns list of URLs on success, empty list on failure
  Future<List<String>> uploadMultiplePostImages(
    List<String> filePaths, {
    int? maxWidth,
    int? quality,
  }) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
    );

    try {
      _logger.i('Uploading ${filePaths.length} post images');

      final uploadedUrls = <String>[];

      for (int i = 0; i < filePaths.length; i++) {
        final filePath = filePaths[i];
        final progress = (i + 1) / filePaths.length;

        state = state.copyWith(
          progress: progress,
          currentFileName: '${i + 1}/${filePaths.length}',
        );

        try {
          final fileName =
              'post_${DateTime.now().millisecondsSinceEpoch}_${i}_${_getFileName(filePath)}';

          final url = await _storageRepository.uploadImage(
            filePath: filePath,
            folder: StorageFolder.posts,
            fileName: fileName,
            maxWidth: maxWidth ?? 1080,
            quality: quality ?? 85,
          );

          uploadedUrls.add(url);
        } catch (e) {
          _logger.e('Failed to upload image ${i + 1}: $e');
        }
      }

      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        error: null,
      );

      _logger.i('Uploaded ${uploadedUrls.length}/${filePaths.length} images');
      return uploadedUrls;
    } catch (e) {
      final errorMsg = 'Failed to upload multiple images: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return [];
    }
  }

  /// Upload a video for posts
  /// Returns the URL of the uploaded video on success, null on failure
  Future<String?> uploadPostVideo(String filePath) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
      currentFileName: _getFileName(filePath),
    );

    try {
      _logger.i('Uploading post video: $filePath');

      final fileName =
          'video_${DateTime.now().millisecondsSinceEpoch}_${_getFileName(filePath)}';

      final url = await _storageRepository.uploadVideo(
        filePath: filePath,
        folder: StorageFolder.videos,
        fileName: fileName,
        onProgress: (progress) {
          state = state.copyWith(
            progress: progress.percentage / 100,
          );
        },
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrl: url,
        progress: 1.0,
        error: null,
      );

      _logger.i('Post video uploaded successfully: $url');
      return url;
    } catch (e) {
      final errorMsg = 'Failed to upload post video: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return null;
    }
  }

  /// Upload a user avatar
  /// Returns the URL of the uploaded avatar on success, null on failure
  Future<String?> uploadAvatar(String filePath) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
      currentFileName: 'avatar',
    );

    try {
      _logger.i('Uploading avatar: $filePath');

      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}';

      final url = await _storageRepository.uploadImage(
        filePath: filePath,
        folder: StorageFolder.avatars,
        fileName: fileName,
        maxWidth: 400,
        quality: 90,
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrl: url,
        progress: 1.0,
        error: null,
      );

      _logger.i('Avatar uploaded successfully: $url');
      return url;
    } catch (e) {
      final errorMsg = 'Failed to upload avatar: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return null;
    }
  }

  /// Upload a user banner/cover photo
  /// Returns the URL of the uploaded banner on success, null on failure
  Future<String?> uploadBanner(String filePath) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
      currentFileName: 'banner',
    );

    try {
      _logger.i('Uploading banner: $filePath');

      final fileName = 'banner_${DateTime.now().millisecondsSinceEpoch}';

      final url = await _storageRepository.uploadImage(
        filePath: filePath,
        folder: StorageFolder.banners,
        fileName: fileName,
        maxWidth: 1200,
        quality: 85,
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrl: url,
        progress: 1.0,
        error: null,
      );

      _logger.i('Banner uploaded successfully: $url');
      return url;
    } catch (e) {
      final errorMsg = 'Failed to upload banner: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return null;
    }
  }

  /// Upload a voice note
  /// Returns the URL of the uploaded voice note on success, null on failure
  Future<String?> uploadVoiceNote(String filePath) async {
    state = state.copyWith(
      isUploading: true,
      progress: 0.0,
      error: null,
      currentFileName: 'voice_note',
    );

    try {
      _logger.i('Uploading voice note: $filePath');

      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}';

      final url = await _storageRepository.uploadVoiceNote(
        filePath: filePath,
        folder: StorageFolder.voice,
        fileName: fileName,
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrl: url,
        progress: 1.0,
        error: null,
      );

      _logger.i('Voice note uploaded successfully: $url');
      return url;
    } catch (e) {
      final errorMsg = 'Failed to upload voice note: $e';
      _logger.e(errorMsg);

      state = state.copyWith(
        isUploading: false,
        error: errorMsg,
      );

      return null;
    }
  }

  /// Delete a file from Cloudinary
  Future<bool> deleteFile(String fileUrl) async {
    try {
      _logger.i('Deleting file: $fileUrl');
      await _storageRepository.deleteFile(fileUrl);
      _logger.i('File deleted successfully');
      return true;
    } catch (e) {
      _logger.e('Failed to delete file: $e');
      return false;
    }
  }

  /// Clear the upload state
  void clearState() {
    state = const UploadState();
  }

  /// Get file name from file path
  String _getFileName(String filePath) {
    return filePath.split('/').last.split('\\').last;
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider for StorageRepositoryImpl (singleton)
final storageRepositoryProvider = Provider<StorageRepositoryImpl>((ref) {
  final logger = ref.watch(loggerProvider);
  return StorageRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
    logger: logger,
  );
});

/// Provider for CloudinaryUploadNotifier
final cloudinaryUploadProvider =
    StateNotifierProvider<CloudinaryUploadNotifier, UploadState>((ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  final logger = ref.watch(loggerProvider);
  return CloudinaryUploadNotifier(storageRepository, logger);
});

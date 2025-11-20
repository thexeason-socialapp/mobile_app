import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/entities/media.dart';
import '../../../../domain/repositories/post_repository.dart';
import '../../../../domain/repositories/storage_repository.dart';
import '../../../../core/di/providers.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'feed_state_provider.dart';

/// Post Composer State
class PostComposerState {
  final String content;
  final List<File> mediaFiles;
  final List<String> uploadedMediaUrls;
  final bool isUploading;
  final double uploadProgress;
  final String? error;
  final PostVisibility visibility;

  const PostComposerState({
    this.content = '',
    this.mediaFiles = const [],
    this.uploadedMediaUrls = const [],
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.error,
    this.visibility = PostVisibility.public,
  });

  bool get hasContent => content.trim().isNotEmpty;
  bool get hasMedia => mediaFiles.isNotEmpty;
  bool get isValid => hasContent || hasMedia;
  bool get canPost => isValid && !isUploading;

  PostComposerState copyWith({
    String? content,
    List<File>? mediaFiles,
    List<String>? uploadedMediaUrls,
    bool? isUploading,
    double? uploadProgress,
    String? error,
    PostVisibility? visibility,
    bool clearError = false,
  }) {
    return PostComposerState(
      content: content ?? this.content,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      uploadedMediaUrls: uploadedMediaUrls ?? this.uploadedMediaUrls,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      error: clearError ? null : (error ?? this.error),
      visibility: visibility ?? this.visibility,
    );
  }
}

/// Post Composer Notifier
class PostComposerNotifier extends StateNotifier<PostComposerState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  final String _userId;

  PostComposerNotifier({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
    required String userId,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        _userId = userId,
        super(const PostComposerState());

  /// Update content
  void updateContent(String content) {
    state = state.copyWith(content: content, clearError: true);
  }

  /// Add media file
  void addMediaFile(File file) {
    if (state.mediaFiles.length >= 4) {
      state = state.copyWith(error: 'Maximum 4 images allowed');
      return;
    }

    final updatedFiles = List<File>.from(state.mediaFiles)..add(file);
    state = state.copyWith(mediaFiles: updatedFiles, clearError: true);
  }

  /// Add multiple media files
  void addMediaFiles(List<File> files) {
    final remainingSlots = 4 - state.mediaFiles.length;
    if (files.length > remainingSlots) {
      state = state.copyWith(
        error: 'Maximum 4 images allowed. You can add $remainingSlots more.',
      );
      return;
    }

    final updatedFiles = List<File>.from(state.mediaFiles)..addAll(files);
    state = state.copyWith(mediaFiles: updatedFiles, clearError: true);
  }

  /// Remove media file at index
  void removeMediaFile(int index) {
    final updatedFiles = List<File>.from(state.mediaFiles)..removeAt(index);
    state = state.copyWith(mediaFiles: updatedFiles, clearError: true);
  }

  /// Clear all media
  void clearMedia() {
    state = state.copyWith(mediaFiles: [], clearError: true);
  }

  /// Update visibility
  void updateVisibility(PostVisibility visibility) {
    state = state.copyWith(visibility: visibility);
  }

  /// Create post
  Future<bool> createPost() async {
    if (!state.canPost) return false;

    state = state.copyWith(isUploading: true, clearError: true);

    try {
      // Generate post ID
      const uuid = Uuid();
      final postId = uuid.v4();

      // Upload media if any
      List<String> mediaUrls = [];
      if (state.mediaFiles.isNotEmpty) {
        mediaUrls = await _uploadMedia(postId);
      }

      // Create post with media URLs
      await _postRepository.createPost(
        userId: _userId,
        content: state.content.trim(),
        mediaPaths: mediaUrls,
        visibility: state.visibility,
      );

      // Refresh feed
      _ref.read(feedProvider.notifier).refresh();

      // Reset state
      state = const PostComposerState();

      return true;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to create post: $e',
      );
      return false;
    }
  }

  /// Upload media files to storage
  Future<List<String>> _uploadMedia(String postId) async {
    final urls = <String>[];
    final totalFiles = state.mediaFiles.length;

    for (var i = 0; i < totalFiles; i++) {
      final file = state.mediaFiles[i];

      // Update progress
      state = state.copyWith(
        uploadProgress: (i / totalFiles),
      );

      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = file.path.split('.').last;
      final fileName = '${_userId}_${postId}_${timestamp}_$i.$extension';

      // Upload file
      final url = await _storageRepository.uploadImage(
        filePath: file.path,
        folder: StorageFolder.posts,
        fileName: fileName,
        maxWidth: 1920,
        quality: 85,
      );

      urls.add(url);
    }

    // Upload complete
    state = state.copyWith(uploadProgress: 1.0);

    return urls;
  }

  /// Reset composer
  void reset() {
    state = const PostComposerState();
  }

  /// Validate media file
  Future<bool> validateMediaFile(File file) async {
    try {
      await _storageRepository.validateFile(
        filePath: file.path,
        maxSizeInMB: 10, // 10MB max for images
        allowedFormats: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Post Composer Provider
final postComposerProvider =
    StateNotifierProvider.autoDispose<PostComposerNotifier, PostComposerState>(
  (ref) {
    final postRepository = ref.watch(postRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    final authState = ref.watch(authProvider);
    final userId = authState.user?.id ?? '';

    return PostComposerNotifier(
      postRepository: postRepository,
      storageRepository: storageRepository,
      ref: ref,
      userId: userId,
    );
  },
);

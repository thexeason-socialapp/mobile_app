import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/post.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../profile/widgets/avatar_widget.dart';
import '../providers/post_composer_provider.dart';

/// Create Post Page - Full screen composer for creating posts
class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Auto-focus on content field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultipleImages(
        maxWidth: 1920,
        imageQuality: 90,
      );

      if (images.isNotEmpty) {
        final files = images.map((image) => File(image.path)).toList();

        // Validate each file
        for (final file in files) {
          final isValid = await ref
              .read(postComposerProvider.notifier)
              .validateMediaFile(file);
          if (!isValid) return;
        }

        ref.read(postComposerProvider.notifier).addMediaFiles(files);
      }
    } catch (e) {
      _showError('Failed to pick images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        imageQuality: 90,
      );

      if (photo != null) {
        final file = File(photo.path);

        // Validate file
        final isValid =
            await ref.read(postComposerProvider.notifier).validateMediaFile(file);
        if (!isValid) return;

        ref.read(postComposerProvider.notifier).addMediaFile(file);
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  Future<void> _submitPost() async {
    final composerState = ref.read(postComposerProvider);

    if (!composerState.canPost) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Create post
    final success = await ref.read(postComposerProvider.notifier).createPost();

    // Close loading dialog
    if (mounted) Navigator.of(context).pop();

    if (success) {
      // Close composer
      if (mounted) context.pop();
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Color(0xFFFFC107),
          ),
        );
      }
    } else {
      // Error already shown in state
      final error = ref.read(postComposerProvider).error;
      if (error != null) {
        _showError(error);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDiscardDialog() {
    final composerState = ref.read(postComposerProvider);

    // If nothing entered, just go back
    if (!composerState.hasContent && !composerState.hasMedia) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard post?'),
        content: const Text(
          'Are you sure you want to discard this post? Your changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(postComposerProvider.notifier).reset();
              Navigator.of(context).pop();
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final composerState = ref.watch(postComposerProvider);
    final currentUser = authState.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _showDiscardDialog,
        ),
        title: const Text('Create Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: composerState.canPost ? _submitPost : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Post'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User header
                  Row(
                    children: [
                      if (currentUser != null)
                        AvatarWidget(
                          imageUrl: currentUser.avatar,
                          displayName: currentUser.displayName,
                          size: 48,
                        )
                      else
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser?.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildVisibilityDropdown(composerState.visibility),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content text field
                  TextField(
                    controller: _contentController,
                    focusNode: _contentFocusNode,
                    maxLines: null,
                    minLines: 3,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: const TextStyle(fontSize: 18),
                    onChanged: (value) {
                      ref.read(postComposerProvider.notifier).updateContent(value);
                    },
                  ),

                  // Character counter
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_contentController.text.length}/500',
                      style: TextStyle(
                        fontSize: 12,
                        color: _contentController.text.length > 450
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Media preview grid
                  if (composerState.mediaFiles.isNotEmpty)
                    _buildMediaGrid(composerState.mediaFiles),

                  // Upload progress
                  if (composerState.isUploading)
                    _buildUploadProgress(composerState.uploadProgress),
                ],
              ),
            ),
          ),

          // Bottom toolbar
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildVisibilityDropdown(PostVisibility visibility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<PostVisibility>(
        value: visibility,
        underline: const SizedBox(),
        isDense: true,
        icon: const Icon(Icons.arrow_drop_down, size: 16),
        items: const [
          DropdownMenuItem(
            value: PostVisibility.public,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.public, size: 14),
                SizedBox(width: 4),
                Text('Public', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          DropdownMenuItem(
            value: PostVisibility.followersOnly,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: 14),
                SizedBox(width: 4),
                Text('Followers', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            ref.read(postComposerProvider.notifier).updateVisibility(value);
          }
        },
      ),
    );
  }

  Widget _buildMediaGrid(List<File> mediaFiles) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        final file = mediaFiles[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  ref.read(postComposerProvider.notifier).removeMediaFile(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadProgress(double progress) {
    return Column(
      children: [
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
        ),
        const SizedBox(height: 8),
        Text(
          'Uploading... ${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomToolbar() {
    final composerState = ref.watch(postComposerProvider);
    final canAddMedia = composerState.mediaFiles.length < 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.photo_library,
              color: canAddMedia ? Colors.grey[700] : Colors.grey[400],
            ),
            onPressed: canAddMedia ? _pickImages : null,
            tooltip: 'Add photos',
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: canAddMedia ? Colors.grey[700] : Colors.grey[400],
            ),
            onPressed: canAddMedia ? _takePhoto : null,
            tooltip: 'Take photo',
          ),
          const Spacer(),
          if (composerState.mediaFiles.isNotEmpty)
            Text(
              '${composerState.mediaFiles.length}/4',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}

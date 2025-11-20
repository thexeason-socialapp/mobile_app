import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features/auth/providers/auth_state_provider.dart';
import '../providers/profile_edit_provider.dart';
import '../widgets/avatar_widget.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _isInitialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('User not found')),
      );
    }

    final editState = ref.watch(profileEditProvider(userId));

    // Initialize form fields when user data is loaded
    if (editState.user != null && !_isInitialized) {
      _displayNameController.text = editState.user!.displayName;
      _bioController.text = editState.user!.bio ?? '';
      _locationController.text = editState.user!.location ?? '';
      _websiteController.text = editState.user!.website ?? '';
      _phoneController.text = editState.user!.phone ?? '';
      _isInitialized = true;
    }

    // Show snackbar for success/error messages
    if (editState.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editState.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(profileEditProvider(userId).notifier).clearSuccess();
      });
    }

    if (editState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editState.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(profileEditProvider(userId).notifier).clearError();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (editState.isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: editState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : editState.user == null
              ? const Center(child: Text('Failed to load profile'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Images Section
                        _buildImageSection(userId, editState),
                        const SizedBox(height: 32),

                        // Form Fields
                        _buildTextField(
                          controller: _displayNameController,
                          label: 'Display Name',
                          hint: 'Enter your display name',
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Display name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Display name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _bioController,
                          label: 'Bio',
                          hint: 'Tell us about yourself',
                          maxLines: 4,
                          maxLength: 150,
                          validator: null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _locationController,
                          label: 'Location',
                          hint: 'Where are you based?',
                          prefixIcon: Icons.location_on,
                          validator: null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _websiteController,
                          label: 'Website',
                          hint: 'https://yourwebsite.com',
                          prefixIcon: Icons.link,
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Website must start with http:// or https://';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          hint: '+1 234 567 8900',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: null,
                        ),
                        const SizedBox(height: 32),

                        // Delete Account Button
                        _buildDangerZone(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildImageSection(String userId, ProfileEditState editState) {
    return Column(
      children: [
        // Banner Image
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: editState.selectedBannerImage != null
                    ? DecorationImage(
                        image: FileImage(File(editState.selectedBannerImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : editState.user?.banner != null
                        ? DecorationImage(
                            image: NetworkImage(editState.user!.banner!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: editState.user?.banner == null &&
                      editState.selectedBannerImage == null
                  ? const Icon(Icons.image, size: 48, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  if (editState.selectedBannerImage != null) ...[
                    IconButton(
                      onPressed: () {
                        ref
                            .read(profileEditProvider(userId).notifier)
                            .clearBannerImage();
                      },
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        if (editState.selectedBannerImage != null) {
                          await ref
                              .read(profileEditProvider(userId).notifier)
                              .uploadBanner(editState.selectedBannerImage!);
                        }
                      },
                      icon: const Icon(Icons.check),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ] else
                    IconButton(
                      onPressed: () => _pickBannerImage(userId),
                      icon: const Icon(Icons.camera_alt),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Avatar
        Center(
          child: Stack(
            children: [
              if (editState.selectedAvatarImage != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(File(editState.selectedAvatarImage!.path)),
                )
              else
                AvatarWidget(
                  imageUrl: editState.user?.avatar,
                  displayName: editState.user?.displayName ?? '',
                  size: 100,
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: editState.selectedAvatarImage != null
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(profileEditProvider(userId).notifier)
                                  .clearAvatarImage();
                            },
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (editState.selectedAvatarImage != null) {
                                await ref
                                    .read(profileEditProvider(userId).notifier)
                                    .uploadAvatar(
                                        editState.selectedAvatarImage!);
                              }
                            },
                            icon: const Icon(Icons.check),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () => _pickAvatarImage(userId),
                        icon: const Icon(Icons.camera_alt),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        counterText: maxLength != null ? null : '',
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Once you delete your account, there is no going back. Please be certain.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showDeleteAccountDialog,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[300]!),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatarImage(String userId) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      // Store the XFile directly - the provider will handle it
      ref
          .read(profileEditProvider(userId).notifier)
          .selectAvatarImage(image);
    }
  }

  Future<void> _pickBannerImage(String userId) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 400,
      imageQuality: 85,
    );

    if (image != null) {
      // Store the XFile directly - the provider will handle it
      ref
          .read(profileEditProvider(userId).notifier)
          .selectBannerImage(image);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      return;
    }

    final success = await ref.read(profileEditProvider(userId).notifier).saveProfile(
          displayName: _displayNameController.text.trim(),
          bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        );

    if (success && mounted) {
      // Go back to profile page
      context.pop();
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you absolutely sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete account
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete account - Coming soon'),
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }
}

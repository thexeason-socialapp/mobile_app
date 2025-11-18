import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../core/di/providers.dart';

/// State for profile editing
class ProfileEditState {
  final User? user;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;
  final File? selectedAvatarImage;
  final File? selectedBannerImage;

  const ProfileEditState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
    this.selectedAvatarImage,
    this.selectedBannerImage,
  });

  ProfileEditState copyWith({
    User? user,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    File? selectedAvatarImage,
    File? selectedBannerImage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearAvatarImage = false,
    bool clearBannerImage = false,
  }) {
    return ProfileEditState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      selectedAvatarImage: clearAvatarImage ? null : (selectedAvatarImage ?? this.selectedAvatarImage),
      selectedBannerImage: clearBannerImage ? null : (selectedBannerImage ?? this.selectedBannerImage),
    );
  }
}

/// ProfileEdit Notifier - Manages profile editing state and operations
class ProfileEditNotifier extends StateNotifier<ProfileEditState> {
  final UserRepository _userRepository;
  final String userId;

  ProfileEditNotifier({
    required UserRepository userRepository,
    required this.userId,
  })  : _userRepository = userRepository,
        super(const ProfileEditState()) {
    _loadUserProfile();
  }

  /// Load user profile for editing
  Future<void> _loadUserProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _userRepository.getUserById(userId);
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Select avatar image
  void selectAvatarImage(File image) {
    state = state.copyWith(selectedAvatarImage: image);
  }

  /// Select banner image
  void selectBannerImage(File image) {
    state = state.copyWith(selectedBannerImage: image);
  }

  /// Clear avatar image selection
  void clearAvatarImage() {
    state = state.copyWith(clearAvatarImage: true);
  }

  /// Clear banner image selection
  void clearBannerImage() {
    state = state.copyWith(clearBannerImage: true);
  }

  /// Save profile changes
  Future<bool> saveProfile({
    required String displayName,
    String? bio,
    String? location,
    String? website,
    String? phone,
  }) async {
    if (state.user == null) {
      state = state.copyWith(error: 'User not loaded');
      return false;
    }

    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      // Update profile
      final updatedUser = await _userRepository.updateProfile(
        userId: userId,
        displayName: displayName,
        bio: bio,
        location: location,
        website: website,
        phone: phone,
      );

      state = state.copyWith(
        user: updatedUser,
        isSaving: false,
        successMessage: 'Profile updated successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Upload avatar image
  Future<bool> uploadAvatar(File imageFile) async {
    if (state.user == null) {
      state = state.copyWith(error: 'User not loaded');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final avatarUrl = await _userRepository.uploadAvatar(
        userId: userId,
        imagePath: imageFile.path,
      );

      final updatedUser = state.user!.copyWith(avatar: avatarUrl);

      state = state.copyWith(
        user: updatedUser,
        isSaving: false,
        successMessage: 'Avatar updated successfully',
        clearAvatarImage: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Upload banner image
  Future<bool> uploadBanner(File imageFile) async {
    if (state.user == null) {
      state = state.copyWith(error: 'User not loaded');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final bannerUrl = await _userRepository.uploadBanner(
        userId: userId,
        imagePath: imageFile.path,
      );

      final updatedUser = state.user!.copyWith(banner: bannerUrl);

      state = state.copyWith(
        user: updatedUser,
        isSaving: false,
        successMessage: 'Banner updated successfully',
        clearBannerImage: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await _loadUserProfile();
  }
}

/// Provider for profile editing
final profileEditProvider = StateNotifierProvider.family<ProfileEditNotifier, ProfileEditState, String>(
  (ref, userId) {
    final userRepository = ref.watch(userRepositoryProvider);
    return ProfileEditNotifier(
      userRepository: userRepository,
      userId: userId,
    );
  },
);

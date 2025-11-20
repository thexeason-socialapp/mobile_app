import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/repositories/storage_repository.dart';
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
  final StorageRepository _storageRepository;
  final String userId;

  ProfileEditNotifier({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required this.userId,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        super(const ProfileEditState());

  /// Load user profile for editing
  Future<void> loadUserProfile() async {
    // Check if already disposed
    if (mounted) {
      state = state.copyWith(isLoading: true, clearError: true);

      try {
        final user = await _userRepository.getUserById(userId);
        if (mounted) {
          state = state.copyWith(
            user: user,
            isLoading: false,
          );
        }
      } catch (e) {
        if (mounted) {
          state = state.copyWith(
            isLoading: false,
            error: e.toString(),
          );
        }
      }
    }
  }

  /// Check if notifier is still mounted
  @override
  bool get mounted => !state.toString().contains('disposed');

  /// Initialization method - call this from the provider
  void init() {
    loadUserProfile();
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
      // Upload to Cloudinary via StorageRepository
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final avatarUrl = await _storageRepository.uploadImage(
        filePath: imageFile.path,
        folder: StorageFolder.avatars,
        fileName: fileName,
        maxWidth: 300,
        quality: 90,
      );

      // Update user profile in Firestore with new avatar URL
      final updatedUser = await _userRepository.updateProfile(
        userId: userId,
        displayName: state.user!.displayName,
      );

      // Update local state with avatar URL
      final userWithAvatar = updatedUser.copyWith(avatar: avatarUrl);

      state = state.copyWith(
        user: userWithAvatar,
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
      // Upload to Cloudinary via StorageRepository
      final fileName = 'banner_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bannerUrl = await _storageRepository.uploadImage(
        filePath: imageFile.path,
        folder: StorageFolder.banners,
        fileName: fileName,
        maxWidth: 1200,
        quality: 85,
      );

      // Update user profile in Firestore with new banner URL
      final updatedUser = await _userRepository.updateProfile(
        userId: userId,
        displayName: state.user!.displayName,
      );

      // Update local state with banner URL
      final userWithBanner = updatedUser.copyWith(banner: bannerUrl);

      state = state.copyWith(
        user: userWithBanner,
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
    await loadUserProfile();
  }
}

/// Provider for profile editing
final profileEditProvider = StateNotifierProvider.family<ProfileEditNotifier, ProfileEditState, String>(
  (ref, userId) {
    final userRepository = ref.watch(userRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    final notifier = ProfileEditNotifier(
      userRepository: userRepository,
      storageRepository: storageRepository,
      userId: userId,
    );
    // Initialize data loading after creation
    notifier.init();
    return notifier;
  },
);

/// Centralized error messages for the app
/// These are user-friendly messages shown in UI
class ErrorMessages {
  ErrorMessages._();
  
  // ===== AUTHENTICATION ERRORS =====
  
  static const String invalidCredentials = 
      'Invalid email or password. Please try again.';
  
  static const String userNotFound = 
      'No account found with this email. Please sign up.';
  
  static const String emailAlreadyInUse = 
      'This email is already registered. Please login instead.';
  
  static const String weakPassword = 
      'Password is too weak. Use at least 8 characters with uppercase, lowercase, numbers and special characters.';
  
  static const String userDisabled = 
      'This account has been disabled. Please contact support.';
  
  static const String tooManyAttempts = 
      'Too many failed attempts. Please try again later.';
  
  static const String emailNotVerified = 
      'Please verify your email address before logging in.';
  
  static const String invalidEmail = 
      'Please enter a valid email address.';
  
  static const String accountSuspended = 
      'Your account has been suspended. Please contact support.';
  
  // ===== NETWORK ERRORS =====
  
  static const String noInternet = 
      'No internet connection. Please check your network and try again.';
  
  static const String poorConnection = 
      'Weak internet connection. Some features may not work properly.';
  
  static const String connectionTimeout = 
      'Connection timed out. Please try again.';
  
  static const String serverUnreachable = 
      'Unable to reach server. Please try again later.';
  
  // ===== SERVER ERRORS =====
  
  static const String serverError = 
      'Something went wrong on our end. Please try again later.';
  
  static const String serviceUnavailable = 
      'Service is temporarily unavailable. Please try again later.';
  
  static const String maintenanceMode = 
      'We\'re currently under maintenance. Please check back soon.';
  
  static const String apiError = 
      'Failed to communicate with server. Please try again.';
  
  // ===== CACHE ERRORS =====
  
  static const String cacheNotFound = 
      'Data not found. Please refresh to load latest content.';
  
  static const String cacheExpired = 
      'Cached data has expired. Refreshing...';
  
  static const String cacheReadFailed = 
      'Failed to load cached data. Please try again.';
  
  static const String cacheWriteFailed = 
      'Failed to save data locally. Please check storage space.';
  
  // ===== VALIDATION ERRORS =====
  
  static const String fieldRequired = 
      'This field is required.';
  
  static const String invalidInput = 
      'Please enter valid information.';
  
  static const String passwordMismatch = 
      'Passwords do not match. Please try again.';
  
  static const String usernameTaken = 
      'This username is already taken. Please choose another.';
  
  static const String invalidPhoneNumber = 
      'Please enter a valid phone number.';
  
  static const String invalidUrl = 
      'Please enter a valid URL.';
  
  // ===== STORAGE ERRORS =====
  
  static const String uploadFailed = 
      'Failed to upload file. Please try again.';
  
  static const String downloadFailed = 
      'Failed to download file. Please try again.';
  
  static const String fileTooLarge = 
      'File is too large. Maximum size is 10MB for images and 100MB for videos.';
  
  static const String invalidFileType = 
      'Unsupported file type. Please choose a different file.';
  
  static const String storageQuotaExceeded = 
      'Storage limit reached. Please delete some files.';
  
  static const String insufficientStorage = 
      'Not enough storage space. Please free up some space.';
  
  // ===== MEDIA ERRORS =====
  
  static const String compressionFailed = 
      'Failed to compress media. Please try a different file.';
  
  static const String invalidMediaFormat = 
      'Unsupported media format. Please use JPG, PNG, or MP4.';
  
  static const String videoProcessingFailed = 
      'Failed to process video. Please try again.';
  
  static const String thumbnailGenerationFailed = 
      'Failed to generate thumbnail.';
  
  // ===== POST ERRORS =====
  
  static const String postNotFound = 
      'This post has been deleted or is no longer available.';
  
  static const String postCreateFailed = 
      'Failed to create post. Please try again.';
  
  static const String postDeleteFailed = 
      'Failed to delete post. Please try again.';
  
  static const String postUpdateFailed = 
      'Failed to update post. Please try again.';
  
  static const String postTooLong = 
      'Post is too long. Maximum 2000 characters allowed.';
  
  static const String postEmpty = 
      'Post cannot be empty. Please add some content.';
  
  // ===== COMMENT ERRORS =====
  
  static const String commentNotFound = 
      'This comment has been deleted or is no longer available.';
  
  static const String commentCreateFailed = 
      'Failed to post comment. Please try again.';
  
  static const String commentDeleteFailed = 
      'Failed to delete comment. Please try again.';
  
  static const String commentTooLong = 
      'Comment is too long. Maximum 500 characters allowed.';
  
  static const String commentEmpty = 
      'Comment cannot be empty.';
  
  // ===== USER ERRORS =====
  
  static const String profileNotFound = 
      'User profile not found.';
  
  static const String profileUpdateFailed = 
      'Failed to update profile. Please try again.';
  
  static const String avatarUploadFailed = 
      'Failed to upload profile picture. Please try again.';
  
  static const String followFailed = 
      'Failed to follow user. Please try again.';
  
  static const String unfollowFailed = 
      'Failed to unfollow user. Please try again.';
  
  // ===== MESSAGE ERRORS =====
  
  static const String messageSendFailed = 
      'Failed to send message. Please try again.';
  
  static const String messageDeleteFailed = 
      'Failed to delete message. Please try again.';
  
  static const String conversationLoadFailed = 
      'Failed to load conversation. Please try again.';
  
  static const String messageEmpty = 
      'Message cannot be empty.';
  
  static const String blockedUser = 
      'You cannot send messages to this user.';
  
  // ===== NOTIFICATION ERRORS =====
  
  static const String notificationsLoadFailed = 
      'Failed to load notifications. Please try again.';
  
  static const String notificationPermissionDenied = 
      'Notification permission denied. Please enable in settings.';
  
  // ===== PERMISSION ERRORS =====
  
  static const String cameraPermissionDenied = 
      'Camera access denied. Please enable in settings.';
  
  static const String galleryPermissionDenied = 
      'Gallery access denied. Please enable in settings.';
  
  static const String storagePermissionDenied = 
      'Storage access denied. Please enable in settings.';
  
  static const String microphonePermissionDenied = 
      'Microphone access denied. Please enable in settings.';
  
  static const String locationPermissionDenied = 
      'Location access denied. Please enable in settings.';
  
  static const String permissionRequired = 
      'This feature requires permission to work.';
  
  // ===== SYNC ERRORS =====
  
  static const String syncFailed = 
      'Failed to sync data. Please try again when online.';
  
  static const String syncConflict = 
      'Data conflict detected. Please refresh and try again.';
  
  static const String pendingSync = 
      'Changes will sync when you\'re back online.';
  
  // ===== RATE LIMIT ERRORS =====
  
  static const String rateLimitExceeded = 
      'Too many requests. Please wait a moment and try again.';
  
  static const String dailyLimitReached = 
      'Daily limit reached. Please try again tomorrow.';
  
  static const String spamDetected = 
      'Suspicious activity detected. Please slow down.';
  
  // ===== SEARCH ERRORS =====
  
  static const String searchFailed = 
      'Search failed. Please try again.';
  
  static const String noSearchResults = 
      'No results found. Try different keywords.';
  
  static const String searchQueryTooShort = 
      'Search query is too short. Please enter at least 3 characters.';
  
  // ===== FEED ERRORS =====
  
  static const String feedLoadFailed = 
      'Failed to load feed. Please pull down to refresh.';
  
  static const String noMorePosts = 
      'You\'ve reached the end. No more posts to load.';
  
  static const String feedEmpty = 
      'No posts yet. Follow people to see their posts here.';
  
  // ===== GENERAL ERRORS =====
  
  static const String unknownError = 
      'Something went wrong. Please try again.';
  
  static const String tryAgainLater = 
      'Please try again later.';
  
  static const String featureUnavailable = 
      'This feature is currently unavailable.';
  
  static const String operationCancelled = 
      'Operation cancelled.';
  
  static const String sessionExpired = 
      'Your session has expired. Please login again.';
  
  // ===== SUCCESS MESSAGES =====
  
  static const String postCreated = 
      'Post created successfully!';
  
  static const String postDeleted = 
      'Post deleted successfully.';
  
  static const String commentPosted = 
      'Comment posted successfully!';
  
  static const String profileUpdated = 
      'Profile updated successfully!';
  
  static const String messageSent = 
      'Message sent!';
  
  static const String loginSuccess = 
      'Welcome back!';
  
  static const String signupSuccess = 
      'Account created successfully! Please verify your email.';
  
  static const String passwordResetSent = 
      'Password reset link sent to your email.';
  
  static const String followSuccess = 
      'You are now following this user.';
  
  static const String unfollowSuccess = 
      'You unfollowed this user.';
  
  // ===== CONFIRMATION MESSAGES =====
  
  static const String deletePostConfirm = 
      'Are you sure you want to delete this post?';
  
  static const String deleteCommentConfirm = 
      'Are you sure you want to delete this comment?';
  
  static const String deleteAccountConfirm = 
      'Are you sure you want to delete your account? This action cannot be undone.';
  
  static const String logoutConfirm = 
      'Are you sure you want to logout?';
  
  static const String unfollowConfirm = 
      'Unfollow this user?';
  
  static const String blockUserConfirm = 
      'Block this user? They won\'t be able to see your posts or send you messages.';
  
  static const String reportConfirm = 
      'Report this content? Our team will review it.';
  
  // ===== LOADING MESSAGES =====
  
  static const String loading = 'Loading...';
  static const String posting = 'Posting...';
  static const String uploading = 'Uploading...';
  static const String processing = 'Processing...';
  static const String deleting = 'Deleting...';
  static const String updating = 'Updating...';
  static const String refreshing = 'Refreshing...';
  static const String syncing = 'Syncing...';
  
  // ===== HELPER METHODS =====
  
  /// Get error message from failure
  static String fromFailure(String failureMessage) {
    // Map common failure messages to user-friendly ones
    final lowercaseMessage = failureMessage.toLowerCase();
    
    if (lowercaseMessage.contains('network') || lowercaseMessage.contains('internet')) {
      return noInternet;
    } else if (lowercaseMessage.contains('timeout')) {
      return connectionTimeout;
    } else if (lowercaseMessage.contains('not found')) {
      return postNotFound;
    } else if (lowercaseMessage.contains('permission')) {
      return permissionRequired;
    } else if (lowercaseMessage.contains('invalid email')) {
      return invalidEmail;
    } else if (lowercaseMessage.contains('wrong password')) {
      return invalidCredentials;
    } else {
      return failureMessage; // Return original if no match
    }
  }
  
  /// Get field-specific validation message
  static String validationMessage(String field) {
    switch (field.toLowerCase()) {
      case 'email':
        return invalidEmail;
      case 'password':
        return 'Password is required';
      case 'username':
        return 'Username is required';
      case 'name':
        return 'Name is required';
      case 'phone':
        return invalidPhoneNumber;
      default:
        return '$field is required';
    }
  }
}
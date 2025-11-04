class AppConstants {
  AppConstants._();
  
  // App Info
  static const String appName = 'Thexeason';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int postsPerPage = 15;
  static const int commentsPerPage = 20;
  static const int messagesPerPage = 50;
  
  // Media Limits
  static const int maxImagesPerPost = 5;
  static const int maxVideoSizeMB = 100;
  static const int maxImageSizeMB = 10;
  static const int maxVoiceNoteDurationSeconds = 120;
  
  // Text Limits
  static const int maxPostLength = 2000;
  static const int maxThreadLength = 280;
  static const int maxCommentLength = 500;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 30;
  
  // Cache Settings
  static const int cachePostsCount = 100;
  static const int cacheUserProfilesCount = 50;
  static const Duration cacheDuration = Duration(hours: 24);
}

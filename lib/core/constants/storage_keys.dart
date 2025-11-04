class StorageKeys {
  StorageKeys._();
  
  // ===== User Data =====
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userToken = 'user_token';
  static const String refreshToken = 'refresh_token';
  
  // ===== Authentication =====
  static const String isLoggedIn = 'is_logged_in';
  static const String authToken = 'auth_token';
  static const String lastLoginTime = 'last_login_time';
  
  // ===== App Settings =====
  static const String isDarkMode = 'is_dark_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String soundEnabled = 'sound_enabled';
  
  // ===== Cache Keys =====
  static const String cachedPosts = 'cached_posts';
  static const String cachedUsers = 'cached_users';
  static const String cachedComments = 'cached_comments';
  static const String lastCacheTime = 'last_cache_time';
  
  // ===== Hive Box Names =====
  static const String postsBox = 'posts_box';
  static const String usersBox = 'users_box';
  static const String commentsBox = 'comments_box';
  static const String draftsBox = 'drafts_box';
  static const String settingsBox = 'settings_box';
  static const String syncQueueBox = 'sync_queue_box';
  
  // ===== FCM =====
  static const String fcmToken = 'fcm_token';
  static const String fcmLastUpdated = 'fcm_last_updated';
  
  // ===== Onboarding =====
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String hasCompletedProfile = 'has_completed_profile';
}
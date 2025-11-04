class RouteConstants {
  RouteConstants._();
  
  // ===== Authentication Routes =====
  // Screens related to user authentication
  static const String splash = '/';                    // First screen app shows (loading)
  static const String onboarding = '/onboarding';      // Intro slides for new users
  static const String login = '/login';                // Email/password login screen
  static const String signup = '/signup';              // Create new account screen
  static const String forgotPassword = '/forgot-password';  // Reset password screen
  static const String verifyEmail = '/verify-email';   // Email verification screen
  
  // ===== Main Navigation Routes =====
  // Bottom navigation bar destinations
  static const String home = '/home';                  // Main feed screen
  static const String explore = '/explore';            // Discover new content
  static const String shorts = '/shorts';              // TikTok-style videos
  static const String messages = '/messages';          // Direct messages list
  static const String profile = '/profile';            // Current user's profile
  
  // ===== Feed Routes =====
  static const String feed = '/feed';                  // Main feed (same as home)
  static const String postDetail = '/post/:postId';    // Single post view (with comments)
  static const String createPost = '/create-post';     // Post composer modal
  
  // ===== Profile Routes =====
  static const String userProfile = '/user/:userId';   // View another user's profile
  static const String editProfile = '/edit-profile';   // Edit own profile
  static const String followers = '/followers/:userId'; // User's followers list
  static const String following = '/following/:userId'; // User's following list
  static const String settings = '/settings';           // App settings
  
  // ===== Messages Routes =====
  static const String conversations = '/conversations'; // All conversations list
  static const String chat = '/chat/:conversationId';  // 1-to-1 chat screen
  static const String newMessage = '/new-message';     // Start new conversation
  
  // ===== Notifications Routes =====
  static const String notifications = '/notifications'; // Notifications feed
  
  // ===== Search Routes =====
  static const String search = '/search';              // Search screen
  static const String searchResults = '/search/:query'; // Search results
  
  // ===== Settings Routes =====
  static const String accountSettings = '/settings/account';     // Account management
  static const String privacySettings = '/settings/privacy';     // Privacy controls
  static const String notificationSettings = '/settings/notifications'; // Notification preferences
  static const String about = '/settings/about';                 // About app
  static const String help = '/settings/help';                   // Help & support
  
  // ===== Threads Routes =====
  static const String threads = '/threads';                   // Twitter-style threads feed
  static const String threadDetail = '/thread/:threadId';     // Single thread view
  static const String createThread = '/create-thread';        // Create thread
  
  // ===== Comments Routes =====
  static const String comments = '/comments/:postId';         // Comments modal/page
  
  // ===== Shorts Routes =====
  static const String shortsDetail = '/shorts/:shortId';      // Single short video
  
  // ===== Error Routes =====
  static const String notFound = '/404';                      // Page not found
  static const String error = '/error';                       // Generic error page
}
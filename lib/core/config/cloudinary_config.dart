import 'env_config.dart';

/// Cloudinary Configuration
/// Centralized configuration for all Cloudinary operations
///
/// Configuration is loaded from .env file via EnvConfig
///
/// Setup:
/// 1. Add to .env file:
///    CLOUDINARY_CLOUD_NAME=your-cloud-name
///    CLOUDINARY_API_KEY=your-api-key
///    CLOUDINARY_API_SECRET=your-api-secret
/// 2. Create Upload Presets in Cloudinary Dashboard > Upload > Upload presets
/// 3. Upload presets should match the preset names defined below
class CloudinaryConfig {
  /// Cloudinary configuration instance (loaded from .env)
  static late final EnvConfig _envConfig;

  /// Initialize Cloudinary config from environment
  static void initialize(EnvConfig envConfig) {
    _envConfig = envConfig;
  }

  /// Your Cloudinary cloud name (unique identifier)
  /// Loaded from: .env CLOUDINARY_CLOUD_NAME
  static String get cloudName => _envConfig.cloudinaryCloudName;

  /// API Key for authentication
  /// Loaded from: .env CLOUDINARY_API_KEY
  static String get apiKey => _envConfig.cloudinaryApiKey;

  /// API Secret for signing requests (KEEP SECURE!)
  /// Never expose this in client-side code
  /// Loaded from: .env CLOUDINARY_API_SECRET
  static String get apiSecret => _envConfig.cloudinaryApiSecret;

  // ============================================================================
  // UPLOAD PRESETS
  // ============================================================================
  // Upload Presets must be created in Cloudinary Dashboard:
  // 1. Go to Settings > Upload > Upload presets
  // 2. Create each preset with the specified settings
  // 3. Set Mode to "Unsigned" for client-side uploads

  /// Upload preset for user avatar images
  /// Settings: Unsigned, Folder: users/avatars, Max: 5MB
  /// Transformations: c_fill,w_400,h_400,g_face,q_auto,f_auto
  static const String avatarPreset = 'user_avatars';

  /// Upload preset for post images
  /// Settings: Unsigned, Folder: posts/media, Max: 10MB
  /// Transformations: c_limit,w_1080,q_auto,f_auto
  static const String postImagePreset = 'post_images';

  /// Upload preset for post videos
  /// Settings: Unsigned, Folder: posts/videos, Max: 100MB
  /// Transformations: q_auto,f_auto,c_scale,w_720
  static const String postVideoPreset = 'post_videos';

  /// Upload preset for voice notes
  /// Settings: Unsigned, Folder: messages/voice, Max: 10MB
  static const String voiceNotePreset = 'voice_notes';

  /// Upload preset for user banner images
  /// Settings: Unsigned, Folder: users/banners, Max: 10MB
  /// Transformations: c_limit,w_1200,q_auto,f_auto
  static const String bannerPreset = 'user_banners';

  // ============================================================================
  // FOLDER STRUCTURE
  // ============================================================================
  // Organize media by type for easier management in Cloudinary

  /// Folder for user avatars
  static const String avatarsFolder = 'users/avatars';

  /// Folder for user banners/cover photos
  static const String bannersFolder = 'users/banners';

  /// Folder for post images
  static const String postsFolder = 'posts/media';

  /// Folder for post videos
  static const String videosFolder = 'posts/videos';

  /// Folder for voice messages/notes
  static const String voiceFolder = 'messages/voice';

  /// Folder for story media (images/videos)
  static const String storiesFolder = 'stories';

  // ============================================================================
  // TRANSFORMATION PRESETS
  // ============================================================================
  // Pre-defined Cloudinary transformations for common use cases
  // Format: "transformation1,transformation2,transformation3"
  // Reference: https://cloudinary.com/documentation/image_transformation_reference

  /// Avatar transformation: Square crop with face detection
  /// - c_fill: Fill entire area
  /// - w_200,h_200: 200x200px size
  /// - g_face: Gravity to face center
  /// - q_auto: Auto quality
  /// - f_auto: Auto format (WebP, AVIF, etc)
  static const String avatarTransform = 'c_fill,w_200,h_200,g_face,q_auto,f_auto';

  /// Avatar large: High-quality avatar for profile header
  static const String avatarLargeTransform = 'c_fill,w_400,h_400,g_face,q_auto,f_auto';

  /// Post image transformation: Limit width while maintaining aspect ratio
  static const String postImageTransform = 'c_limit,w_1080,q_auto,f_auto';

  /// Thumbnail transformation: Square crop for feed thumbnails
  static const String thumbnailTransform = 'c_fill,w_300,h_300,q_auto,f_auto';

  /// Feed image: Optimized for social media feed display
  static const String feedImageTransform = 'c_limit,w_600,q_auto,f_auto';

  /// Banner transformation: Wide image for cover photos
  static const String bannerTransform = 'c_limit,w_1200,h_400,q_auto,f_auto';

  /// Mobile responsive: Smaller images for mobile devices
  static const String mobileTransform = 'c_limit,w_480,q_auto,f_auto';

  /// Tablet responsive: Medium images for tablets
  static const String tabletTransform = 'c_limit,w_768,q_auto,f_auto';

  /// Desktop responsive: Large images for desktop
  static const String desktopTransform = 'c_limit,w_1920,q_auto,f_auto';

  /// Video thumbnail: Optimized video poster image
  static const String videoThumbnailTransform = 'c_fill,w_400,h_225,q_auto,f_auto';

  // ============================================================================
  // FILE SIZE LIMITS (bytes)
  // ============================================================================

  /// Maximum avatar image size: 5MB
  static const int maxAvatarSize = 5 * 1024 * 1024;

  /// Maximum post image size: 10MB
  static const int maxPostImageSize = 10 * 1024 * 1024;

  /// Maximum video size: 100MB
  static const int maxVideoSize = 100 * 1024 * 1024;

  /// Maximum voice note size: 10MB
  static const int maxVoiceNoteSize = 10 * 1024 * 1024;

  /// Maximum banner size: 10MB
  static const int maxBannerSize = 10 * 1024 * 1024;

  // ============================================================================
  // COMPRESSION SETTINGS
  // ============================================================================

  /// Default JPEG quality for image compression (0-100)
  static const int defaultImageQuality = 85;

  /// High quality for avatars (0-100)
  static const int avatarImageQuality = 90;

  /// Maximum width for images before compression
  static const int defaultMaxWidth = 1080;

  // ============================================================================
  // URL GENERATION HELPERS
  // ============================================================================

  /// Base Cloudinary URL for resource delivery
  static const String baseUrl = 'https://res.cloudinary.com';

  /// Get the full base URL for this cloud
  static String get cloudinaryBaseUrl => '$baseUrl/$cloudName';

  /// Get image upload URL
  static String get imageUploadUrl => '$cloudinaryBaseUrl/image/upload';

  /// Get video upload URL
  static String get videoUploadUrl => '$cloudinaryBaseUrl/video/upload';

  /// Get raw file upload URL (for documents, audio)
  static String get rawUploadUrl => '$cloudinaryBaseUrl/raw/upload';

  // ============================================================================
  // API ENDPOINTS
  // ============================================================================

  /// Cloudinary API base URL
  static const String apiBaseUrl = 'https://api.cloudinary.com/v1_1';

  /// Get API endpoint for this cloud
  static String get apiUrl => '$apiBaseUrl/$cloudName';

  /// Get admin API endpoint (requires authentication)
  static String get adminApiUrl => '$apiUrl/resources';

  // ============================================================================
  // ALLOWED FORMATS
  // ============================================================================

  /// Allowed image formats
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

  /// Allowed video formats
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'];

  /// Allowed audio formats
  static const List<String> allowedAudioFormats = ['mp3', 'm4a', 'wav', 'aac', 'flac'];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get upload preset for a given folder type
  static String getUploadPreset(String folderType) {
    switch (folderType.toLowerCase()) {
      case 'avatars':
        return avatarPreset;
      case 'banners':
        return bannerPreset;
      case 'posts':
        return postImagePreset;
      case 'videos':
        return postVideoPreset;
      case 'voice':
        return voiceNotePreset;
      case 'stories':
        return postImagePreset;
      default:
        return postImagePreset;
    }
  }

  /// Get folder path for a given folder type
  static String getFolderPath(String folderType) {
    switch (folderType.toLowerCase()) {
      case 'avatars':
        return avatarsFolder;
      case 'banners':
        return bannersFolder;
      case 'posts':
        return postsFolder;
      case 'videos':
        return videosFolder;
      case 'voice':
        return voiceFolder;
      case 'stories':
        return storiesFolder;
      default:
        return postsFolder;
    }
  }

  /// Get transformation preset for a given type
  static String getTransformation(String transformType) {
    switch (transformType.toLowerCase()) {
      case 'avatar':
        return avatarTransform;
      case 'avatar_large':
        return avatarLargeTransform;
      case 'post_image':
        return postImageTransform;
      case 'thumbnail':
        return thumbnailTransform;
      case 'feed':
        return feedImageTransform;
      case 'banner':
        return bannerTransform;
      case 'mobile':
        return mobileTransform;
      case 'tablet':
        return tabletTransform;
      case 'desktop':
        return desktopTransform;
      case 'video_thumbnail':
        return videoThumbnailTransform;
      default:
        return postImageTransform;
    }
  }

  /// Get max file size for a given media type
  static int getMaxFileSize(String mediaType) {
    switch (mediaType.toLowerCase()) {
      case 'avatar':
        return maxAvatarSize;
      case 'banner':
        return maxBannerSize;
      case 'image':
        return maxPostImageSize;
      case 'video':
        return maxVideoSize;
      case 'voice':
        return maxVoiceNoteSize;
      default:
        return maxPostImageSize;
    }
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
/// Loads configuration from .env file
class EnvConfig {
  // Cloudinary Configuration
  final String cloudinaryCloudName;
  final String cloudinaryApiKey;
  final String cloudinaryApiSecret;

  // R2 Storage Configuration (legacy, for fallback)
  final String r2AccessKey;
  final String r2SecretKey;
  final String r2BucketName;
  final String r2AccountId;
  final String r2Endpoint;
  final String r2PublicUrl;

  // Storage Provider Selection
  final StorageProvider storageProvider;

  EnvConfig({
    required this.cloudinaryCloudName,
    required this.cloudinaryApiKey,
    required this.cloudinaryApiSecret,
    required this.r2AccessKey,
    required this.r2SecretKey,
    required this.r2BucketName,
    required this.r2AccountId,
    required this.r2Endpoint,
    required this.r2PublicUrl,
    this.storageProvider = StorageProvider.cloudinary, // Default to Cloudinary
  });

  /// Load configuration from .env file
  static Future<EnvConfig> load() async {
    try {
      await dotenv.load(fileName: '.env');

      return EnvConfig(
        // Cloudinary
        cloudinaryCloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
        cloudinaryApiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
        cloudinaryApiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
        // R2 (for fallback)
        r2AccessKey: dotenv.env['CLOUDFLARE_R2_ACCESS_KEY'] ?? '',
        r2SecretKey: dotenv.env['CLOUDFLARE_R2_SECRET_KEY'] ?? '',
        r2BucketName: dotenv.env['CLOUDFLARE_R2_BUCKET_NAME'] ?? 'thexeason-media',
        r2AccountId: dotenv.env['CLOUDFLARE_R2_ACCOUNT_ID'] ?? '',
        r2Endpoint: dotenv.env['CLOUDFLARE_R2_ENDPOINT'] ?? '',
        r2PublicUrl: dotenv.env['CLOUDFLARE_R2_PUBLIC_URL'] ?? '',
        storageProvider: _parseStorageProvider(
          dotenv.env['STORAGE_PROVIDER'] ?? 'cloudinary',
        ),
      );
    } catch (e) {
      // Return default config if .env not found
      return EnvConfig(
        cloudinaryCloudName: '',
        cloudinaryApiKey: '',
        cloudinaryApiSecret: '',
        r2AccessKey: '',
        r2SecretKey: '',
        r2BucketName: 'thexeason-media',
        r2AccountId: '',
        r2Endpoint: '',
        r2PublicUrl: '',
        storageProvider: StorageProvider.cloudinary,
      );
    }
  }

  /// Check if Cloudinary is configured
  bool get isCloudinaryConfigured =>
      cloudinaryCloudName.isNotEmpty &&
      cloudinaryApiKey.isNotEmpty &&
      cloudinaryApiSecret.isNotEmpty;

  /// Check if R2 is configured
  bool get isR2Configured =>
      r2AccessKey.isNotEmpty &&
      r2SecretKey.isNotEmpty &&
      r2Endpoint.isNotEmpty;

  /// Parse storage provider from string
  static StorageProvider _parseStorageProvider(String value) {
    switch (value.toLowerCase()) {
      case 'cloudinary':
        return StorageProvider.cloudinary;
      case 'r2':
      case 'cloudflare':
        return StorageProvider.r2;
      case 'firebase':
        return StorageProvider.firebase;
      default:
        return StorageProvider.cloudinary;
    }
  }
}

/// Available storage providers
enum StorageProvider {
  cloudinary,
  r2,
  firebase,
}

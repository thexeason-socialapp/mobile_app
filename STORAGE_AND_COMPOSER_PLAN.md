# Storage Migration & Post Composer Implementation Plan

## Overview
This document outlines the plan to migrate from Firebase Storage to Cloudflare R2 and implement the post composer feature.

---

## Phase 1: Cloudflare R2 Storage Integration

### 1.1 Why Cloudflare R2?
- **No egress fees** (vs Firebase Storage charges for downloads)
- **S3-compatible API** (easy migration path)
- **Lower costs** for media-heavy apps
- **Better global performance** with Cloudflare's CDN
- **More control** over storage lifecycle

### 1.2 Architecture Design

#### Storage Abstraction Layer
Create a storage interface that allows swapping between different providers:

```dart
// lib/domain/repositories/storage_repository.dart
abstract class StorageRepository {
  Future<String> uploadImage({
    required File file,
    required String path,
    String? contentType,
  });

  Future<String> uploadVideo({
    required File file,
    required String path,
  });

  Future<void> deleteFile(String path);

  Future<String> getDownloadUrl(String path);
}
```

#### Implementation Structure
```
lib/
├── data/
│   ├── datasources/
│   │   └── remote/
│   │       └── storage/
│   │           ├── storage_service.dart          # Abstract interface
│   │           ├── firebase_storage_service.dart # Firebase implementation
│   │           └── r2_storage_service.dart       # Cloudflare R2 implementation
│   └── repositories/
│       └── storage_repository_impl.dart          # Concrete repository
```

### 1.3 Cloudflare R2 Setup Requirements

#### Prerequisites
1. **Cloudflare Account** with R2 enabled
2. **R2 Bucket** created (e.g., `thexeason-media`)
3. **API Token** with R2 permissions
4. **S3-compatible credentials**:
   - Access Key ID
   - Secret Access Key
   - Bucket endpoint URL

#### Environment Variables
```env
# .env
CLOUDFLARE_R2_ACCESS_KEY=your_access_key
CLOUDFLARE_R2_SECRET_KEY=your_secret_key
CLOUDFLARE_R2_BUCKET_NAME=thexeason-media
CLOUDFLARE_R2_ENDPOINT=https://your-account-id.r2.cloudflarestorage.com
CLOUDFLARE_R2_PUBLIC_URL=https://media.thexeason.com  # Custom domain (optional)
```

### 1.4 Required Dependencies

```yaml
# pubspec.yaml
dependencies:
  # Existing
  firebase_storage: ^11.7.0

  # New for R2
  minio: ^4.0.3              # S3-compatible client for R2
  flutter_dotenv: ^5.1.0     # Environment variable management
  http: ^1.2.0               # For direct HTTP uploads
  mime: ^1.0.4               # MIME type detection
  path: ^1.8.3               # Path manipulation
```

### 1.5 Implementation Steps

#### Step 1: Create Storage Service Interface
```dart
// lib/data/datasources/remote/storage/storage_service.dart
abstract class StorageService {
  Future<UploadResult> uploadFile({
    required File file,
    required String path,
    required MediaType mediaType,
    Function(double)? onProgress,
  });

  Future<void> deleteFile(String path);
  Future<String> getPublicUrl(String path);
}

class UploadResult {
  final String url;
  final String path;
  final int size;
  final String mimeType;

  const UploadResult({
    required this.url,
    required this.path,
    required this.size,
    required this.mimeType,
  });
}
```

#### Step 2: Implement R2 Storage Service
```dart
// lib/data/datasources/remote/storage/r2_storage_service.dart
class R2StorageService implements StorageService {
  final Minio _client;
  final String _bucketName;
  final String _publicUrl;

  R2StorageService({
    required String endpoint,
    required String accessKey,
    required String secretKey,
    required String bucketName,
    required String publicUrl,
  }) : _bucketName = bucketName,
       _publicUrl = publicUrl,
       _client = Minio(
         endPoint: endpoint,
         accessKey: accessKey,
         secretKey: secretKey,
       );

  @override
  Future<UploadResult> uploadFile({...}) async {
    // Generate unique path
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final fullPath = '$path/$fileName';

    // Upload to R2
    await _client.fPutObject(_bucketName, fullPath, file.path);

    // Return public URL
    final url = '$_publicUrl/$fullPath';
    return UploadResult(...);
  }
}
```

#### Step 3: Create Storage Repository
```dart
// lib/data/repositories/storage_repository_impl.dart
class StorageRepositoryImpl implements StorageRepository {
  final StorageService _storageService;

  StorageRepositoryImpl({required StorageService storageService})
      : _storageService = storageService;

  @override
  Future<String> uploadImage({...}) async {
    final result = await _storageService.uploadFile(
      file: file,
      path: path,
      mediaType: MediaType.image,
    );
    return result.url;
  }
}
```

#### Step 4: Update Dependency Injection
```dart
// lib/core/di/providers.dart

// Environment config provider
final envConfigProvider = Provider((ref) {
  return EnvConfig(
    r2AccessKey: dotenv.env['CLOUDFLARE_R2_ACCESS_KEY']!,
    r2SecretKey: dotenv.env['CLOUDFLARE_R2_SECRET_KEY']!,
    r2BucketName: dotenv.env['CLOUDFLARE_R2_BUCKET_NAME']!,
    r2Endpoint: dotenv.env['CLOUDFLARE_R2_ENDPOINT']!,
    r2PublicUrl: dotenv.env['CLOUDFLARE_R2_PUBLIC_URL']!,
  );
});

// Storage service provider (switchable)
final storageServiceProvider = Provider<StorageService>((ref) {
  final config = ref.read(envConfigProvider);

  // Return R2 service (can add feature flag to switch)
  return R2StorageService(
    endpoint: config.r2Endpoint,
    accessKey: config.r2AccessKey,
    secretKey: config.r2SecretKey,
    bucketName: config.r2BucketName,
    publicUrl: config.r2PublicUrl,
  );
});

// Storage repository provider
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return StorageRepositoryImpl(storageService: storageService);
});
```

### 1.6 Migration Strategy

#### Option A: Immediate Switch (Recommended)
- All new uploads go to R2
- Existing Firebase URLs continue to work
- Gradually migrate old media in background

#### Option B: Dual Storage
- Upload to both Firebase and R2 temporarily
- Verify R2 works correctly
- Switch to R2-only after verification

---

## Phase 2: Update Profile Feature for R2

### 2.1 Changes Required

#### Update ProfileEditProvider
```dart
// lib/presentation/features/profile/providers/profile_edit_provider.dart

// OLD: Uses Firebase Storage directly
Future<String?> uploadAvatar(File imageFile) async {
  final storage = _ref.read(firebaseStorageProvider);
  // ... Firebase upload code
}

// NEW: Uses Storage Repository
Future<String?> uploadAvatar(File imageFile) async {
  final storageRepo = _ref.read(storageRepositoryProvider);
  try {
    final url = await storageRepo.uploadImage(
      file: imageFile,
      path: 'avatars/$userId',
    );
    return url;
  } catch (e) {
    // Error handling
  }
}
```

### 2.2 Path Structure in R2
```
thexeason-media/
├── avatars/
│   └── {userId}/
│       └── {timestamp}_{filename}.jpg
├── banners/
│   └── {userId}/
│       └── {timestamp}_{filename}.jpg
└── posts/
    └── {userId}/
        └── {postId}/
            ├── {timestamp}_{filename}.jpg
            └── {timestamp}_{filename}.mp4
```

---

## Phase 3: Post Composer Feature

### 3.1 User Flow
1. User taps FAB on Feed page
2. Composer sheet/page opens
3. User types content
4. User can add media (images/videos)
5. User can see preview
6. User taps "Post"
7. Upload progress shown
8. Post appears in feed

### 3.2 Component Structure

```
lib/presentation/features/feed/
├── pages/
│   └── create_post_page.dart        # Full screen composer
├── widgets/
│   ├── post_composer_sheet.dart     # Bottom sheet variant
│   ├── media_picker_widget.dart     # Image/video picker
│   ├── media_preview_grid.dart      # Show selected media
│   └── post_submit_button.dart      # Post button with loading
└── providers/
    └── post_composer_provider.dart  # State management
```

### 3.3 State Management

```dart
// Post composer state
class PostComposerState {
  final String content;
  final List<File> mediaFiles;
  final List<String> uploadedMediaUrls;
  final bool isUploading;
  final double uploadProgress;
  final String? error;
  final bool canPost;

  bool get hasContent => content.trim().isNotEmpty;
  bool get hasMedia => mediaFiles.isNotEmpty;
  bool get isValid => hasContent || hasMedia;
}
```

### 3.4 Key Features

#### Content Editor
- Multi-line text input
- Character counter (optional limit)
- Auto-growing text field
- Hashtag/mention detection (future)

#### Media Selection
- Image picker (single/multiple)
- Video picker (single)
- Camera capture option
- Media preview with delete option
- Max 4 images or 1 video per post

#### Upload Process
1. **Optimistic Creation**: Create post in Firestore immediately
2. **Background Upload**: Upload media to R2
3. **Update Post**: Update post document with media URLs
4. **Notify Feed**: Refresh feed provider

```dart
Future<void> createPost() async {
  // 1. Create post with placeholder
  final post = await _postRepository.createPost(...);

  // 2. Upload media in background
  if (mediaFiles.isNotEmpty) {
    final urls = await _uploadMedia(post.id);

    // 3. Update post with URLs
    await _postRepository.updatePost(
      postId: post.id,
      media: urls,
    );
  }

  // 4. Refresh feed
  _ref.read(feedProvider.notifier).refresh();
}
```

### 3.5 UI Design Checklist

- [ ] Minimal, clean composer interface
- [ ] Smooth bottom sheet animation
- [ ] Media preview thumbnails
- [ ] Upload progress indicator
- [ ] Error handling UI
- [ ] "Discard draft" confirmation
- [ ] Post visibility options (public/followers)
- [ ] Loading state on submit button

---

## Phase 4: Implementation Order

### Week 1: Storage Setup
1. ✅ Day 1: Create storage abstraction layer
2. ✅ Day 2: Implement R2 storage service
3. ✅ Day 3: Update DI and configuration
4. ✅ Day 4: Update profile feature to use new storage
5. ✅ Day 5: Testing and bug fixes

### Week 2: Post Composer
1. ✅ Day 1: Create composer state provider
2. ✅ Day 2: Build composer UI (text input)
3. ✅ Day 3: Add media picker integration
4. ✅ Day 4: Implement upload logic
5. ✅ Day 5: Connect to feed refresh

### Week 3: Polish & Testing
1. ✅ Error handling
2. ✅ Loading states
3. ✅ Image compression
4. ✅ Video validation
5. ✅ End-to-end testing

---

## Phase 5: Additional Considerations

### 5.1 Image Optimization
```dart
// Compress images before upload
Future<File> compressImage(File image) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    image.absolute.path,
    targetPath,
    quality: 85,
    maxWidth: 1920,
    maxHeight: 1920,
  );
  return result;
}
```

### 5.2 Video Validation
- Max file size: 100MB
- Max duration: 60 seconds
- Supported formats: MP4, MOV
- Auto-compression if needed

### 5.3 Error Scenarios
- Network failure during upload → Retry logic
- Storage quota exceeded → User notification
- Invalid file type → Clear error message
- Upload timeout → Cancel and retry

### 5.4 Performance
- Lazy load media thumbnails
- Compress images before upload
- Show upload progress
- Cancel ongoing uploads on discard

---

## Phase 6: Testing Plan

### Unit Tests
- [ ] Storage service upload/delete methods
- [ ] Post composer state transitions
- [ ] Image compression logic
- [ ] URL generation

### Integration Tests
- [ ] End-to-end post creation flow
- [ ] Media upload and retrieval
- [ ] Feed refresh after post creation

### Manual Tests
- [ ] Create text-only post
- [ ] Create post with 1 image
- [ ] Create post with 4 images
- [ ] Create post with video
- [ ] Upload progress accuracy
- [ ] Error handling (no internet)
- [ ] Discard draft confirmation

---

## Phase 7: Future Enhancements

### Post Composer V2
- [ ] Save drafts locally
- [ ] Schedule posts
- [ ] Location tagging
- [ ] Tag other users
- [ ] Poll creation
- [ ] GIF support
- [ ] Audio posts

### Storage Optimizations
- [ ] CDN integration for R2
- [ ] Image transformation on-the-fly
- [ ] Video transcoding
- [ ] Thumbnail generation
- [ ] Progressive image loading

---

## Estimated Timeline
- **Storage Migration**: 3-5 days
- **Post Composer MVP**: 5-7 days
- **Testing & Polish**: 2-3 days
- **Total**: ~2 weeks

## Next Steps
1. Set up Cloudflare R2 account and bucket
2. Add environment variables
3. Install required dependencies
4. Implement storage abstraction layer
5. Begin post composer development

---

**Questions to Resolve Before Starting:**
1. Do you have a Cloudflare account with R2 enabled?
2. Should we implement both storage options with a feature flag?
3. What's the max file size for uploads? (recommend 10MB images, 100MB videos)
4. Do you want video support in V1 or just images?
5. Full-page composer or bottom sheet?

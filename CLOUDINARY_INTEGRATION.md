# 🔥 Cloudinary Integration Guide - TheXeason App

Complete implementation guide for Cloudinary media management in TheXeason social app.

## 📋 Overview

Cloudinary replaces Firebase Storage for all media operations:
- ✅ Image uploads (avatars, posts, banners)
- ✅ Video uploads (posts, stories)
- ✅ Voice note uploads (messages)
- ✅ Auto-compression and optimization
- ✅ CDN delivery with smart transformations
- ✅ Responsive image delivery

## 🚀 Quick Start

### 1. Setup Cloudinary Account

1. Sign up at [cloudinary.com](https://cloudinary.com)
2. Get your **Cloud Name** from Dashboard > Settings > Cloud Name
3. Get your **API Key** from Dashboard > Settings > Access Keys
4. Get your **API Secret** from Dashboard > Settings > Access Keys

### 2. Configure Credentials

Update `lib/core/config/cloudinary_config.dart`:

```dart
class CloudinaryConfig {
  static const String cloudName = 'your-cloud-name';
  static const String apiKey = 'your-api-key';
  static const String apiSecret = 'your-api-secret';
  // ... rest of config
}
```

### 3. Create Upload Presets

In Cloudinary Dashboard > Upload > Upload presets, create these unsigned presets:

#### Avatar Preset: `user_avatars`
- **Mode:** Unsigned
- **Folder:** `users/avatars`
- **Transformations:** `c_fill,w_400,h_400,g_face,q_auto,f_auto`
- **Max file size:** 5MB
- **Allowed formats:** jpg, png, webp

#### Post Images Preset: `post_images`
- **Mode:** Unsigned
- **Folder:** `posts/media`
- **Transformations:** `c_limit,w_1080,q_auto,f_auto`
- **Max file size:** 10MB
- **Allowed formats:** jpg, png, webp

#### Post Videos Preset: `post_videos`
- **Mode:** Unsigned
- **Folder:** `posts/videos`
- **Transformations:** `q_auto,f_auto,c_scale,w_720`
- **Max file size:** 100MB
- **Allowed formats:** mp4, mov, avi

#### Voice Notes Preset: `voice_notes`
- **Mode:** Unsigned
- **Folder:** `messages/voice`
- **Max file size:** 10MB
- **Allowed formats:** mp3, m4a, wav

#### Banner Preset: `user_banners`
- **Mode:** Unsigned
- **Folder:** `users/banners`
- **Transformations:** `c_limit,w_1200,q_auto,f_auto`
- **Max file size:** 10MB
- **Allowed formats:** jpg, png, webp

## 📚 Core Components

### 1. CloudinaryConfig (`lib/core/config/cloudinary_config.dart`)

Central configuration file with:
- Cloud credentials
- Upload presets mapping
- Folder structure definitions
- Transformation presets
- File size limits
- Helper methods

```dart
// Get transformation for avatar
final transform = CloudinaryConfig.getTransformation('avatar');

// Get max file size
final maxSize = CloudinaryConfig.getMaxFileSize('image');

// Get upload preset for folder
final preset = CloudinaryConfig.getUploadPreset('avatars');
```

### 2. CloudinaryStorageService (`lib/data/datasources/remote/storage/cloudinary_storage_service.dart`)

HTTP API wrapper with:
- Direct Cloudinary API integration
- Signature generation for authenticated uploads
- Transformation helpers
- Multi-platform support (web, iOS, Android)

**Key Methods:**
```dart
// Upload file with progress tracking
Future<UploadResult> uploadFile({
  required dynamic file,
  required String path,
  required MediaType mediaType,
  Function(double)? onProgress,
})

// Get optimized URLs
String getOptimizedAvatarUrl(String url, {int size = 200})
String getOptimizedBannerUrl(String url)
String getMobileOptimizedUrl(String url)
String getTabletOptimizedUrl(String url)
String getDesktopOptimizedUrl(String url)

// Video thumbnails
String getVideoThumbnailUrl(String videoUrl, {int width = 400, int height = 225})

// Responsive URLs
Map<String, String> getResponsiveImageUrls(String url)
```

### 3. CloudinaryImageWidget (`lib/shared/widgets/media/cloudinary_image_widget.dart`)

Smart image display component with:
- Auto-responsive transformations
- Caching via CachedNetworkImage
- Placeholder and error handling
- Face detection for avatars
- Customizable transformation presets

**Example Usage:**

```dart
// Basic avatar
CloudinaryImageWidget(
  imageUrl: user.avatarUrl,
  width: 100,
  height: 100,
  transformationType: 'avatar',
  borderRadius: BorderRadius.circular(50),
)

// Post image with custom size
CloudinaryImageWidget(
  imageUrl: post.imageUrl,
  width: 300,
  height: 400,
  transformationType: 'post_image',
  fit: BoxFit.cover,
)

// Responsive feed image
CloudinaryImageWidget(
  imageUrl: post.imageUrl,
  transformationType: 'feed',
  borderRadius: BorderRadius.circular(12),
  showLoadingIndicator: true,
)

// Custom transformations
CloudinaryImageWidget(
  imageUrl: imageUrl,
  customTransformations: ['w_500', 'h_500', 'c_fill', 'q_90'],
  gravity: 'face',
)
```

### 4. CloudinaryVideoWidget (`lib/shared/widgets/media/cloudinary_video_widget.dart`)

Video player component with:
- Auto-optimized video URLs
- Built-in player controls
- Thumbnail support
- Play/pause functionality
- Progress bar
- Loading states

**Example Usage:**

```dart
CloudinaryVideoWidget(
  videoUrl: post.videoUrl,
  width: 300,
  height: 200,
  autoPlay: false,
  showControls: true,
  borderRadius: BorderRadius.circular(12),
)

// With custom thumbnail
CloudinaryVideoWidget(
  videoUrl: videoUrl,
  width: 400,
  height: 300,
  thumbnailUrl: customThumbnailUrl,
)

// Auto-play muted (for feeds)
CloudinaryVideoWidget(
  videoUrl: videoUrl,
  autoPlay: true,
  muted: true,
  loop: true,
)
```

### 5. CloudinaryUploadProvider (`lib/presentation/providers/cloudinary_upload_provider.dart`)

Riverpod state management for uploads with:
- Upload state tracking
- Progress monitoring
- Error handling
- Type-specific upload methods
- File deletion

**Key Methods:**

```dart
// Upload post image
Future<String?> uploadPostImage(
  String filePath, {
  int? maxWidth,
  int? quality,
})

// Upload multiple images
Future<List<String>> uploadMultiplePostImages(
  List<String> filePaths, {
  int? maxWidth,
  int? quality,
})

// Upload video
Future<String?> uploadPostVideo(String filePath)

// Upload avatar
Future<String?> uploadAvatar(String filePath)

// Upload banner
Future<String?> uploadBanner(String filePath)

// Upload voice note
Future<String?> uploadVoiceNote(String filePath)

// Delete file
Future<bool> deleteFile(String fileUrl)
```

**Usage in Widgets:**

```dart
final uploadState = ref.watch(cloudinaryUploadProvider);

ElevatedButton(
  onPressed: () async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      final url = await ref
          .read(cloudinaryUploadProvider.notifier)
          .uploadPostImage(file.path);
    }
  },
  child: Text('Upload Image'),
)

// Show progress
if (uploadState.isUploading) {
  LinearProgressIndicator(value: uploadState.progress)
}

// Show error
if (uploadState.error != null) {
  Text('Error: ${uploadState.error}')
}

// Display uploaded image
if (uploadState.uploadedUrl != null) {
  CloudinaryImageWidget(imageUrl: uploadState.uploadedUrl!)
}
```

## 🎯 Usage Examples

### Upload Avatar

```dart
class AvatarUploadWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends ConsumerState<AvatarUploadWidget> {
  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(cloudinaryUploadProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: _pickAndUploadAvatar,
          child: uploadState.uploadedUrl != null
              ? CloudinaryImageWidget(
                  imageUrl: uploadState.uploadedUrl!,
                  width: 100,
                  height: 100,
                  transformationType: 'avatar',
                  borderRadius: BorderRadius.circular(50),
                )
              : CircleAvatar(radius: 50, child: Icon(Icons.camera)),
        ),
        if (uploadState.isUploading)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      await ref
          .read(cloudinaryUploadProvider.notifier)
          .uploadAvatar(file.path);
    }
  }
}
```

### Create Post with Images

```dart
class CreatePostPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  List<String> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(cloudinaryUploadProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image preview
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return CloudinaryImageWidget(
                  imageUrl: selectedImages[index],
                  transformationType: 'thumbnail',
                );
              },
            ),

            // Upload progress
            if (uploadState.isUploading) ...[
              SizedBox(height: 16),
              LinearProgressIndicator(value: uploadState.progress),
              Text('${(uploadState.progress * 100).toStringAsFixed(0)}%'),
            ],

            // Add images button
            ElevatedButton.icon(
              onPressed: _selectImages,
              icon: Icon(Icons.add_photo_alternate),
              label: Text('Add Images'),
            ),

            // Post button
            ElevatedButton(
              onPressed: uploadState.isUploading ? null : _createPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    final files = await ImagePicker().pickMultiImage();
    if (files.isNotEmpty) {
      final urls = await ref
          .read(cloudinaryUploadProvider.notifier)
          .uploadMultiplePostImages(files.map((f) => f.path).toList());

      setState(() => selectedImages.addAll(urls));
    }
  }

  Future<void> _createPost() async {
    // Create post with selectedImages URLs
  }
}
```

### Display Post with Video

```dart
class PostCard extends StatelessWidget {
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Avatar
          ListTile(
            leading: CloudinaryImageWidget(
              imageUrl: post.author.avatarUrl,
              width: 40,
              height: 40,
              transformationType: 'avatar',
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(post.author.name),
          ),

          // Video content
          if (post.videoUrl != null)
            CloudinaryVideoWidget(
              videoUrl: post.videoUrl!,
              width: double.infinity,
              height: 300,
              autoPlay: false,
            ),

          // Image content
          if (post.imageUrls.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: post.imageUrls.length == 1 ? 1 : 2,
              ),
              itemCount: post.imageUrls.length,
              itemBuilder: (context, index) {
                return CloudinaryImageWidget(
                  imageUrl: post.imageUrls[index],
                  transformationType: 'feed',
                );
              },
            ),

          // Engagement buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
                IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🔐 Security Best Practices

1. **Never expose API Secret in client code** - Only use API Key for client uploads
2. **Use Upload Presets** - Set size limits, formats, and folders on Cloudinary
3. **Enable HTTPS** - All Cloudinary URLs are served over HTTPS
4. **Validate file types** - Check MIME types before uploading
5. **Delete old media** - Clean up replaced avatars/banners

## ⚡ Performance Tips

1. **Image Compression** - Always compress before upload (done automatically)
2. **Responsive Images** - Use `getResponsiveImageUrls()` for different devices
3. **Caching** - CloudinaryImageWidget uses CachedNetworkImage by default
4. **Lazy Loading** - Load images only when needed in feeds
5. **Video Thumbnails** - Use `getVideoThumbnailUrl()` instead of loading full video

## 🐛 Troubleshooting

### Upload fails with "signature mismatch"
- Verify API Secret is correct
- Check timestamp is synchronized
- Ensure upload preset matches

### Images not showing transformations
- Verify URL contains `/upload/` segment
- Check transformation syntax
- Ensure Cloudinary recognizes the public ID

### Video playback issues
- Check supported format (mp4, webm)
- Verify network optimization is enabled
- Try different video URL format

### Web platform issues
- Use `XFile` instead of `File` for web
- Check CORS settings in Cloudinary dashboard
- Verify blob URL handling

## 📊 Cloudinary Dashboard Features

### Monitor Usage
- Dashboard > Analytics > Overview
- Track storage, bandwidth, transformations
- View cost estimates

### Manage Resources
- Dashboard > Media Library
- Search and organize by folder
- View transformation history

### Configure Settings
- Dashboard > Settings > Upload
- Create/edit upload presets
- Configure security policies
- Set rate limits

## 🔗 Useful Links

- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Upload API Reference](https://cloudinary.com/documentation/image_upload_api_reference)
- [Transformation Reference](https://cloudinary.com/documentation/image_transformation_reference)
- [Flutter SDK](https://pub.dev/packages/cloudinary_flutter)

## 📝 Integration Checklist

- [ ] Cloudinary account created
- [ ] Cloud Name, API Key, API Secret obtained
- [ ] `cloudinary_config.dart` configured
- [ ] Upload presets created in dashboard
- [ ] CloudinaryStorageService integrated
- [ ] CloudinaryImageWidget implemented
- [ ] CloudinaryVideoWidget implemented
- [ ] CloudinaryUploadProvider created
- [ ] Profile avatar upload working
- [ ] Post image upload working
- [ ] Post video upload working
- [ ] Voice note upload working
- [ ] Responsive images tested
- [ ] Progress indicators working
- [ ] Error handling tested
- [ ] All platforms tested (web, iOS, Android)

## 🚀 Next Steps

1. Replace all Firebase Storage references with Cloudinary
2. Update existing media URLs to use transformations
3. Implement offline upload queue (optional)
4. Add image cropping before upload (optional)
5. Implement video compression (optional)

---

**Last Updated:** 2024
**Status:** Complete and Ready for Production

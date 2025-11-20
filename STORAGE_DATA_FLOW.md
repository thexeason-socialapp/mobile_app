# Storage Data Flow Diagram

Visual guide to how data flows through your storage system.

---

## Complete Upload Flow

```
USER INTERFACE LAYER
════════════════════════════════════════════════════════════

User opens Feed
    ↓
Taps yellow (+) button
    ↓
CreatePostPage opens
    ↓
    ├─ User types content
    └─ User selects images
        ↓
        Image Picker Dialog
        ├─ [Gallery] → Select 1-4 images
        └─ [Camera] → Capture photo
            ↓
            Images stored in File objects
            ↓
            LocalValidation runs
            ├─ Check file size (max 10MB)
            ├─ Check format (.jpg, .png, etc)
            └─ Check count (max 4)
                ↓
                ✅ VALID → Add to mediaFiles
                ❌ INVALID → Show error


PRESENTATION LAYER
════════════════════════════════════════════════════════════

CreatePostPage (_CreatePostPageState)
    ↓
    Shows TextInput for content
    Shows MediaPreview grid (up to 4 images)
    Shows MediaPickerToolbar (+ camera, + gallery)
    ↓
User taps "Post" button
    ↓
_submitPost() called
    ↓
    postComposerProvider.notifier.createPost()
        ↓
        STATE MANAGEMENT:
        PostComposerNotifier (StateNotifier<PostComposerState>)

            State contains:
            ├─ content: String (post text)
            ├─ mediaFiles: List<File> (local files)
            ├─ uploadedMediaUrls: List<String> (Cloudinary URLs)
            ├─ isUploading: bool
            ├─ uploadProgress: double (0.0 - 1.0)
            ├─ error: String?
            └─ visibility: PostVisibility


STATE MANAGEMENT LAYER
════════════════════════════════════════════════════════════

PostComposerNotifier.createPost()
    ↓
    1. Show loading dialog
        state = state.copyWith(isUploading: true)
    ↓
    2. Upload media files
        if (state.mediaFiles.isNotEmpty)
            _uploadMedia(postId) {
                for each file:
                    a) Compress locally
                       - Max 1920px
                       - 85% quality
                    ↓
                    b) Generate filename
                       - userID_postID_timestamp_index.ext
                    ↓
                    c) Call storageRepository.uploadImage()
                       ↓
                       STORAGE LAYER →
                    ↓
                    d) Receive URL from Cloudinary
                       https://res.cloudinary.com/dcwlprnaa/image/upload/...
                    ↓
                    e) Add to uploadedMediaUrls list
                    ↓
                    f) Track progress (i / total)
                       state = state.copyWith(uploadProgress: progress)
            }
    ↓
    3. Create post in Firestore
        postRepository.createPost(
            userId: userId,
            content: content,
            mediaPaths: uploadedMediaUrls,  ← Cloudinary URLs!
            visibility: visibility
        )
    ↓
    4. Refresh feed
        feedProvider.notifier.refresh()
    ↓
    5. Reset state
        state = PostComposerState() (empty)
    ↓
    6. Return success = true


STORAGE LAYER
════════════════════════════════════════════════════════════

storageRepository.uploadImage()
    ↓
    StorageRepositoryImpl.uploadImage()
        ↓
        1. Compress image locally
           FlutterImageCompress.compressAndGetFile()

           Input:  original_file.jpg (2MB)
               ↓
           Process: Compress to 1920px, 85% quality
               ↓
           Output: compressed.jpg (300KB)
        ↓
        2. Call storageService.uploadFile()
           (auto-selected: Cloudinary/R2/Firebase)
        ↓
        3. Get response
           UploadResult {
             url: "https://res.cloudinary.com/.../image.jpg"
             path: "posts/userId/postId_timestamp.jpg"
             size: 300000
             mimeType: "image/jpeg"
             uploadedAt: DateTime
           }
        ↓
        4. Return URL


CLOUDINARY SERVICE
════════════════════════════════════════════════════════════

CloudinaryStorageService.uploadFile()
    ↓
    Input:
    ├─ File: compressed image file
    ├─ Path: "posts/userId/filename"
    ├─ MediaType: image
    └─ onProgress: callback
    ↓
    1. Extract folder and filename
       folder = "posts/userId"
       filename = "postId_timestamp.jpg"
    ↓
    2. Create HTTP multipart request
       POST → https://api.cloudinary.com/v1_1/dcwlprnaa/image/upload
    ↓
    3. Add fields
       ├─ file: compressed image
       ├─ api_key: dcwlprnaa_api_key
       ├─ folder: posts/userId
       ├─ public_id: postId_timestamp
       └─ overwrite: true
    ↓
    4. Send to Cloudinary
       ↓
       Cloudinary servers process:
       ├─ Store image
       ├─ Generate thumbnail
       ├─ Optimize for different formats
       ├─ Deploy to CDN
       └─ Return response
    ↓
    5. Parse response
       Extract: "secure_url": "https://res.cloudinary.com/..."
    ↓
    6. Return UploadResult
       url: "https://res.cloudinary.com/dcwlprnaa/image/upload/v123/posts/userId/postId_timestamp.jpg"


DATA PERSISTENCE
════════════════════════════════════════════════════════════

Post saved to Firestore:
{
  id: "post_uuid",
  userId: "user_id",
  content: "This is my post!",
  media: [
    {
      url: "https://res.cloudinary.com/dcwlprnaa/image/upload/v123/posts/userId/filename.jpg",
      type: "image"
    }
  ],
  visibility: "public",
  createdAt: 2025-11-20T...,
  likeCount: 0,
  commentCount: 0
}


FEED DISPLAY
════════════════════════════════════════════════════════════

FeedPage loads posts from Firestore
    ↓
For each post:
    ├─ Display content (text)
    └─ For each media:
        ├─ Display image using CachedNetworkImage
        │   ↓
        │   URL: "https://res.cloudinary.com/dcwlprnaa/image/upload/v123/posts/userId/filename.jpg"
        │   ↓
        │   Cloudinary CDN serves:
        │   ├─ Auto-compressed
        │   ├─ Optimized for device
        │   ├─ Cached at edge
        │   └─ Fast delivery
        │
        └─ Optional: Apply transformations
            ├─ getThumbnailUrl() → 200x200 thumb
            ├─ getAvatarUrl() → 150x150 face-crop
            └─ getResponsiveUrl() → Mobile-optimized


ERROR HANDLING FLOW
════════════════════════════════════════════════════════════

At any point, if error occurs:
    ↓
    catch (e) {
        state = state.copyWith(
            isUploading: false,
            error: e.toString()
        )
    }
    ↓
    UI reacts:
    ├─ Loading dialog closes
    ├─ Error message shown (red snackbar)
    └─ Post button re-enabled (can retry)
    ↓
    User can:
    ├─ Tap Post again (retry)
    ├─ Fix issue and try again
    └─ Or abandon post


DEPENDENCY INJECTION
════════════════════════════════════════════════════════════

When app starts:

main.dart
    ↓
    await EnvConfig.load()  ← Reads .env file
    ├─ CLOUDINARY_CLOUD_NAME=dcwlprnaa
    ├─ CLOUDINARY_API_KEY=***
    └─ CLOUDINARY_API_SECRET=***
    ↓
    App initializes providers
    ↓
    When CreatePostPage builds:
        ↓
        ref.read(postComposerProvider.notifier)
        ↓
        Creates PostComposerNotifier with:
        ├─ postRepository ← from providers
        ├─ storageRepository ← from providers
        └─ ref ← Riverpod context
        ↓
        storageRepository comes from:
        ↓
        storageRepositoryProvider {
            storageService = storageServiceProvider
            ↓
            storageServiceProvider {
                config = envConfigProvider
                ↓
                if (config.isCloudinaryConfigured)
                    → CloudinaryStorageService
                else if (config.isR2Configured)
                    → R2StorageService
                else
                    → FirebaseStorageService
            }
        }


CONFIGURATION PRIORITY
════════════════════════════════════════════════════════════

Storage provider auto-selection:

1. CLOUDINARY
   if configured (.env has all 3 values) → USE IT ✅

2. R2 (Cloudflare)
   if configured (.env has credentials) → USE IT

3. FIREBASE (Fallback)
   always available (built-in) → USE IT


EXAMPLE COMPLETE FLOW
════════════════════════════════════════════════════════════

User action:         "Create post with 2 images"
                     ↓
Image 1 selected:    IMG_0001.jpg (2MB)
Image 2 selected:    IMG_0002.jpg (1.5MB)
                     ↓
Validation:          Both files valid ✅
                     ↓
Compression:         IMG_0001.jpg → 250KB
                     IMG_0002.jpg → 200KB
                     Total savings: 3.25MB → 450KB (86% reduction!)
                     ↓
Upload to Cloudinary:
  Image 1: 250KB uploaded → ~0.5 seconds
  Image 2: 200KB uploaded → ~0.4 seconds
  Progress shown: 0% → 50% → 100%
                     ↓
Cloudinary response:
  Image 1 URL: https://res.cloudinary.com/dcwlprnaa/image/upload/v123/posts/user123/post456_1732073456_0.jpg
  Image 2 URL: https://res.cloudinary.com/dcwlprnaa/image/upload/v123/posts/user123/post456_1732073456_1.jpg
                     ↓
Post created:        Content + 2 URLs saved to Firestore
                     ↓
Feed refreshed:      New post appears at top
                     ↓
Image display:       CachedNetworkImage loads from CDN
                     ├─ Auto-optimized format (WebP/JPEG)
                     ├─ Responsive size (mobile = 400px, desktop = 800px)
                     └─ Fast delivery (global CDN cache)
                     ↓
User sees:           Post with beautifully optimized images! 🎉


SUMMARY
════════════════════════════════════════════════════════════

User → UI → State → Storage Service → Cloudinary → CDN → User Feed

Clean, efficient, and optimized at every step! ✅

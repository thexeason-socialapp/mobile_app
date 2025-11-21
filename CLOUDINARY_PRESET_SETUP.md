# 🚀 Cloudinary Upload Presets Setup Guide

## ✅ Your Credentials
```
Cloud Name: dcwlprnaa
API Key: 395391741421529
API Secret: kpi6ozKTHzI9G5-H6oSPNB4-6Wc
```

---

## 📋 5 Upload Presets to Create

You need to create these 5 unsigned upload presets in your Cloudinary Dashboard:

1. **user_avatars** - For user profile pictures
2. **post_images** - For post images
3. **post_videos** - For post videos
4. **voice_notes** - For voice messages
5. **user_banners** - For cover photos

---

## 🔗 Direct Link to Cloudinary Dashboard

**Go to:** https://cloudinary.com/console/c/dcwlprnaa/settings/upload

Or manually:
1. Visit https://cloudinary.com
2. Sign in with your account
3. Click **Settings** (gear icon)
4. Click **Upload** tab
5. Scroll to **Upload presets** section

---

## 📝 Preset #1: user_avatars

### Basic Settings:
- **Preset Name:** `user_avatars`
- **Mode:** Unsigned ✅ (IMPORTANT for client-side uploads)
- **Folder:** `users/avatars`
- **Public ID prefix:** Leave empty

### Upload Settings:
- **Max file size:** 5 MB
- **Allowed formats:** jpg, jpeg, png, webp

### Transformation Settings:
```
c_fill,w_400,h_400,g_face,q_auto,f_auto
```

Breakdown:
- `c_fill` - Fill the 400x400 box
- `w_400,h_400` - 400x400 pixel size
- `g_face` - **Smart face detection** for centering
- `q_auto` - Auto quality optimization
- `f_auto` - Auto format (WebP, AVIF, etc)

**Click Save**

---

## 📝 Preset #2: post_images

### Basic Settings:
- **Preset Name:** `post_images`
- **Mode:** Unsigned ✅
- **Folder:** `posts/media`
- **Public ID prefix:** Leave empty

### Upload Settings:
- **Max file size:** 10 MB
- **Allowed formats:** jpg, jpeg, png, webp, gif

### Transformation Settings:
```
c_limit,w_1080,q_auto,f_auto
```

Breakdown:
- `c_limit` - Limit to max 1080px width (maintain aspect ratio)
- `w_1080` - Max width 1080px
- `q_auto` - Auto quality
- `f_auto` - Auto format

**Click Save**

---

## 📝 Preset #3: post_videos

### Basic Settings:
- **Preset Name:** `post_videos`
- **Mode:** Unsigned ✅
- **Folder:** `posts/videos`
- **Public ID prefix:** Leave empty

### Upload Settings:
- **Max file size:** 100 MB
- **Allowed formats:** mp4, mov, avi, mkv, flv, wmv
- **Eager transformations:** (Optional, for thumbnails)

### Transformation Settings (Optional):
```
q_auto,f_auto,c_scale,w_720
```

Breakdown:
- `q_auto` - Auto quality
- `f_auto` - Auto format
- `c_scale,w_720` - Scale to 720px width

**Click Save**

---

## 📝 Preset #4: voice_notes

### Basic Settings:
- **Preset Name:** `voice_notes`
- **Mode:** Unsigned ✅
- **Folder:** `messages/voice`
- **Public ID prefix:** Leave empty

### Upload Settings:
- **Max file size:** 10 MB
- **Allowed formats:** mp3, m4a, wav, aac, flac

### Transformation Settings:
Leave empty (audio doesn't need transformations)

**Click Save**

---

## 📝 Preset #5: user_banners

### Basic Settings:
- **Preset Name:** `user_banners`
- **Mode:** Unsigned ✅
- **Folder:** `users/banners`
- **Public ID prefix:** Leave empty

### Upload Settings:
- **Max file size:** 10 MB
- **Allowed formats:** jpg, jpeg, png, webp

### Transformation Settings:
```
c_limit,w_1200,q_auto,f_auto
```

Breakdown:
- `c_limit` - Limit to max 1200px width
- `w_1200` - Max width 1200px
- `q_auto` - Auto quality
- `f_auto` - Auto format

**Click Save**

---

## ✅ Verification Checklist

After creating all presets, verify:

- [ ] `user_avatars` preset exists
  - [ ] Mode: Unsigned
  - [ ] Folder: users/avatars
  - [ ] Max size: 5 MB
  - [ ] Transformation: c_fill,w_400,h_400,g_face,q_auto,f_auto

- [ ] `post_images` preset exists
  - [ ] Mode: Unsigned
  - [ ] Folder: posts/media
  - [ ] Max size: 10 MB
  - [ ] Transformation: c_limit,w_1080,q_auto,f_auto

- [ ] `post_videos` preset exists
  - [ ] Mode: Unsigned
  - [ ] Folder: posts/videos
  - [ ] Max size: 100 MB
  - [ ] Allowed formats: mp4, mov, avi, etc

- [ ] `voice_notes` preset exists
  - [ ] Mode: Unsigned
  - [ ] Folder: messages/voice
  - [ ] Max size: 10 MB
  - [ ] Allowed formats: mp3, m4a, wav, etc

- [ ] `user_banners` preset exists
  - [ ] Mode: Unsigned
  - [ ] Folder: users/banners
  - [ ] Max size: 10 MB
  - [ ] Transformation: c_limit,w_1200,q_auto,f_auto

---

## 🎯 Why These Settings?

### Unsigned Mode
- Allows client-side uploads without backend signature
- Security is enforced via preset constraints
- Users can upload directly from app

### Folder Organization
- `users/` - All user-related media
- `posts/` - All post-related media
- `messages/` - Message-related media
- Easy to manage and organize in dashboard

### Max File Sizes
- Avatar: 5 MB - Small profile pics
- Post images: 10 MB - Feed images
- Post videos: 100 MB - Larger video files
- Voice notes: 10 MB - Audio files
- Banners: 10 MB - Cover photos

### Transformations
- `c_fill/c_limit` - Smart cropping
- `w_###` - Responsive widths
- `g_face` - Face detection for avatars
- `q_auto` - Best quality for bandwidth
- `f_auto` - Best format for browser

---

## 🧪 Test Your Setup

After creating presets, test in your app:

```dart
// In your app, this should work:
final url = await ref.read(cloudinaryUploadProvider.notifier)
    .uploadAvatar(filePath);

// Should upload successfully using preset constraints
```

### Expected behavior:
1. File is uploaded to Cloudinary
2. Automatically saved to correct folder
3. Automatically transformed
4. URL returned to app

---

## 🆘 Troubleshooting

### "Preset not found" error?
- Check preset name matches exactly (case-sensitive)
- Verify preset is set to "Unsigned" mode
- Ensure preset is saved

### Upload exceeds file size?
- Check max file size in preset settings
- Increase if needed
- Currently: Avatar 5MB, Images 10MB, Videos 100MB, Voice 10MB

### Wrong transformation applied?
- Verify transformation string is correct
- Check for typos in preset settings
- Transformation is applied automatically

### Folder structure different?
- Files go to folder specified in preset
- You can organize in dashboard later
- Current: users/, posts/, messages/

---

## 📊 Summary

| Preset | Folder | Max Size | Formats | Transformation |
|--------|--------|----------|---------|-----------------|
| user_avatars | users/avatars | 5 MB | jpg,png,webp | c_fill,w_400,h_400,g_face,q_auto,f_auto |
| post_images | posts/media | 10 MB | jpg,png,webp,gif | c_limit,w_1080,q_auto,f_auto |
| post_videos | posts/videos | 100 MB | mp4,mov,avi,mkv,flv,wmv | q_auto,f_auto,c_scale,w_720 |
| voice_notes | messages/voice | 10 MB | mp3,m4a,wav,aac,flac | (none) |
| user_banners | users/banners | 10 MB | jpg,png,webp | c_limit,w_1200,q_auto,f_auto |

---

## 🚀 Next Steps

1. ✅ Go to Cloudinary Dashboard
2. ✅ Create all 5 presets
3. ✅ Verify each preset is set to "Unsigned"
4. ✅ Test upload in your app
5. ✅ Done!

---

## 💡 Pro Tips

1. **Test with different file sizes** to ensure max file size is appropriate
2. **Check dashboard** to see uploaded files organized by folder
3. **Monitor bandwidth** - auto format/quality saves bandwidth
4. **Use Cloudinary's Media Library** to view and manage all uploads
5. **Adjust transformations later** without changing app code

---

## 📞 Need Help?

If you have issues:
1. Check preset exists in Cloudinary Dashboard
2. Verify preset name matches code exactly
3. Ensure preset is "Unsigned" mode
4. Check max file sizes are appropriate
5. Look at Cloudinary's transformation docs

---

**Status:** Ready to create presets! 🎉

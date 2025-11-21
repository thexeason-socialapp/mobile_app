# ⚡ Cloudinary Presets - Quick Reference

## 🔗 Direct Link
**https://cloudinary.com/console/c/dcwlprnaa/settings/upload**

---

## 📋 Copy-Paste Values

### Preset 1️⃣: user_avatars
```
Name:          user_avatars
Mode:          Unsigned ✅
Folder:        users/avatars
Max Size:      5 MB
Formats:       jpg, jpeg, png, webp
Transform:     c_fill,w_400,h_400,g_face,q_auto,f_auto
```

### Preset 2️⃣: post_images
```
Name:          post_images
Mode:          Unsigned ✅
Folder:        posts/media
Max Size:      10 MB
Formats:       jpg, jpeg, png, webp, gif
Transform:     c_limit,w_1080,q_auto,f_auto
```

### Preset 3️⃣: post_videos
```
Name:          post_videos
Mode:          Unsigned ✅
Folder:        posts/videos
Max Size:      100 MB
Formats:       mp4, mov, avi, mkv, flv, wmv
Transform:     q_auto,f_auto,c_scale,w_720
```

### Preset 4️⃣: voice_notes
```
Name:          voice_notes
Mode:          Unsigned ✅
Folder:        messages/voice
Max Size:      10 MB
Formats:       mp3, m4a, wav, aac, flac
Transform:     (leave empty)
```

### Preset 5️⃣: user_banners
```
Name:          user_banners
Mode:          Unsigned ✅
Folder:        users/banners
Max Size:      10 MB
Formats:       jpg, jpeg, png, webp
Transform:     c_limit,w_1200,q_auto,f_auto
```

---

## ✅ Steps to Create Each Preset

1. Go to **Settings > Upload > Upload presets**
2. Click **Add upload preset**
3. Fill in values from above
4. Set **Mode** to **Unsigned** ✅ (CRITICAL!)
5. Click **Save**
6. Repeat for all 5 presets

---

## 🎯 Key Things to Remember

✅ **Mode MUST be: Unsigned** - For client-side uploads
✅ **Folder path** - Organizes files in dashboard
✅ **Max file size** - Security constraint
✅ **Allowed formats** - File type validation
✅ **Transformation** - Auto resize/optimize

---

## 🧪 Test After Setup

Run this in your app:
```dart
final url = await ref.read(cloudinaryUploadProvider.notifier)
    .uploadAvatar(filePath);
```

Should work immediately! ✅

---

## 📊 All Presets At A Glance

| # | Name | Use | Size | Transform |
|---|------|-----|------|-----------|
| 1 | user_avatars | Profile pics | 5MB | Face crop |
| 2 | post_images | Feed images | 10MB | Limit 1080w |
| 3 | post_videos | Videos | 100MB | Scale 720w |
| 4 | voice_notes | Audio | 10MB | None |
| 5 | user_banners | Cover photos | 10MB | Limit 1200w |

---

## ⏱️ Estimated Time

- Setup: **5-10 minutes** (create 5 presets)
- Testing: **2-3 minutes**
- Total: **~15 minutes** to go live!

---

**You're ready!** 🚀

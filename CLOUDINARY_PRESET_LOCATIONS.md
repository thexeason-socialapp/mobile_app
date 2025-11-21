# 🔍 Finding Upload Preset Options in Cloudinary Dashboard

## 📍 Where to Find File Size Limit

The file size option might be in a different location depending on your Cloudinary interface version.

### ✅ Option 1: In Upload Preset Settings (Most Common)

1. Go to **Settings > Upload > Upload presets**
2. Click on an existing preset OR create new one
3. Look for these sections:

```
BASIC SETTINGS
├── Preset Name
├── Mode (Unsigned)
├── Folder
└── Public ID

UPLOAD SETTINGS  ← FILE SIZE IS HERE
├── Max file size (in MB)
├── Allowed file types/formats
└── Eager transformations

TRANSFORMATION
├── Upload transformation
└── Named transformation
```

### ✅ Option 2: Under "Advanced" or "More Options"

If you don't see "Max file size" in the main settings:
1. Look for an **"Advanced"** button or **"More options"** link
2. It might be collapsed - click to expand
3. File size limit should appear there

### ✅ Option 3: Check Security Settings

File size limits might also be under:
1. **Settings > Security > Upload restrictions**
2. Look for "Max upload size" or "File size limit"

---

## 🎯 If You Can't Find It

**Don't worry!** The file size limit is OPTIONAL. Here's why:

1. **Preset constraints are optional** - Your app has its own validation
2. **Cloudinary has account-wide limits** - Based on your plan
3. **Your app validates before upload** - StorageRepository checks file size

### What matters most:
✅ **Preset Name** (must match code)
✅ **Mode: Unsigned** (for client uploads)
✅ **Folder** (organization)
✅ **Allowed formats** (jpg, png, etc.)
✅ **Transformation** (auto resize/optimize)

---

## 📋 Minimum Required for Each Preset

If you can only set these:

| Field | Value |
|-------|-------|
| Preset Name | `user_avatars` (or other name) |
| Mode | `Unsigned` ✅ |
| Folder | `users/avatars` |
| Allowed formats | jpg, png, webp |
| Transformation | c_fill,w_400,h_400,g_face,q_auto,f_auto |

**The app will still work!** Your Flutter code validates file sizes anyway.

---

## 🔐 Where File Size Is Actually Validated

Your app validates file sizes in **TWO places**:

### 1. StorageRepository (lib/data/repositories/storage_repository_impl.dart)
```dart
@override
Future<void> validateFile({
  required String filePath,
  int? maxSizeInMB,  // ← File size checked here
  List<String>? allowedFormats,
}) async {
  final file = File(filePath);
  final fileSize = await file.length();
  final maxSizeInBytes = maxSizeInMB * 1024 * 1024;

  if (fileSize > maxSizeInBytes) {
    throw Exception('File too large');
  }
}
```

### 2. CloudinaryStorageService (lib/data/datasources/remote/storage/cloudinary_storage_service.dart)
- Checks file size before sending to Cloudinary
- Multipart request automatically validates

---

## 💡 So What About Cloudinary's File Size Limit?

**You have options:**

### Option A: Set in Preset (Recommended)
```
Go to Preset > Upload Settings > Max file size
Set: 5 MB (avatar), 10 MB (images), 100 MB (video)
```

### Option B: Leave Default
- Use Cloudinary's account defaults
- Your app validates anyway
- Still works perfectly

### Option C: Check Your Plan Limits
1. Go to **Settings > Plan**
2. Check your maximum upload size
3. That's your limit

---

## 🎯 Quick Summary

| Situation | Action |
|-----------|--------|
| **Found "Max file size"** | Set it (recommended) |
| **Can't find it** | Skip it (optional) |
| **Cloudinary rejects upload** | Check plan limits |
| **App rejects before upload** | StorageRepository validation working |

---

## ✅ Complete Preset Without File Size Limit

You can create a working preset with just these fields:

```
Preset Name:       user_avatars
Mode:              Unsigned ✅ (CRITICAL)
Folder:            users/avatars
Allowed Formats:   jpg, jpeg, png, webp
Transformation:    c_fill,w_400,h_400,g_face,q_auto,f_auto
```

**This is enough!** Your app will work.

---

## 🆘 Still Can't Find It?

Try these alternatives:

### Check Cloudinary Docs
- **Cloudinary Upload Preset Docs**: https://cloudinary.com/documentation/upload_presets

### Ask Cloudinary Support
1. Click **Help** (?) icon in dashboard
2. Chat with Cloudinary support
3. They can guide you to file size settings

### Alternative: Use API
Create presets via API instead of UI:
- Uses Cloudinary's Admin API
- More reliable
- But requires backend code

---

## 🚀 Bottom Line

**You don't need the file size limit to get started!**

1. Create the 5 presets with minimum fields
2. Set Mode to **Unsigned** ✅
3. Set the **Folder** names
4. Set the **Transformation** strings
5. Test in your app

File size validation happens in your Flutter app anyway. **You're good to go!**

---

## 📝 Preset Creation Checklist (Minimum)

- [ ] Preset name set correctly
- [ ] Mode set to "Unsigned" ✅
- [ ] Folder path set (users/avatars, etc.)
- [ ] Allowed formats selected (jpg, png, etc.)
- [ ] Transformation string entered
- [ ] Preset saved successfully

**That's it!** Create all 5 and you're done! 🎉

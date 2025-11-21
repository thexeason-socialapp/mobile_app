# 🗄️ Database Persistence Guide - Cloudinary Upload Integration

## Overview

Your Cloudinary uploads are now **fully integrated with Firestore database and Hive cache**. When you upload an avatar or banner, it's automatically saved to the database and can be retrieved even after app restart.

---

## 📊 Complete Data Flow

### Avatar Upload Process (Step-by-Step)

```
1. User selects avatar image in Edit Profile
   ↓
2. ProfileEditPage calls profileEditProvider.uploadAvatar(imageFile)
   ↓
3. ProfileEditProvider:
   - Calls CloudinaryUploadProvider.uploadAvatar(imagePath)
   ↓
4. CloudinaryUploadProvider:
   - Uploads image file to Cloudinary API
   - Returns Cloudinary URL
   ↓
5. Back in ProfileEditProvider:
   - Calls UserRepository.updateUserAvatarUrl(userId, cloudinaryUrl)
   ↓
6. UserRepository:
   - Calls UsersApi.updateUserAvatarUrl(userId, avatarUrl)
   ↓
7. UsersApi:
   - Updates Firestore user document with avatar URL
   - Sets updatedAt timestamp
   ↓
8. UserRepository:
   - Calls UserBox.saveUser(updatedUserModel)
   - Saves to local Hive cache
   ↓
9. ProfileEditProvider:
   - Updates local state with persisted user
   - Shows success message
   ↓
10. UI Updates:
    - Avatar image displayed from URL
    - Cached by CachedNetworkImage for fast loading
```

### Complete Integration Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                      Presentation Layer                         │
│  EditProfilePage → ProfileEditProvider → ProfileEditNotifier    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Cloudinary Upload Layer                      │
│         CloudinaryUploadProvider → CloudinaryStorageService     │
│                  → Cloudinary API (Remote)                      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                  Domain Repository Layer                        │
│              UserRepository (abstract interface)                │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Data Layer (Multiple Sources)                │
│  ┌──────────────────┐    ┌──────────────────┐                  │
│  │   UsersApi       │    │     UserBox      │                  │
│  │   (Firestore)    │    │   (Hive Cache)   │                  │
│  └──────────────────┘    └──────────────────┘                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Schema

### Firestore User Document

**Collection:** `users`
**Document ID:** `{userId}`

```json
{
  "id": "user123",
  "email": "user@example.com",
  "username": "johndoe",
  "displayName": "John Doe",
  "bio": "Software developer",
  "avatar": "https://res.cloudinary.com/.../avatar_1234567890",
  "banner": "https://res.cloudinary.com/.../banner_1234567890",
  "followers": 42,
  "following": 15,
  "postsCount": 8,
  "createdAt": "2024-11-21T10:30:00Z",
  "updatedAt": "2024-11-21T15:45:00Z",
  "isPrivate": false,
  "location": "San Francisco, CA",
  "website": "https://example.com",
  "phone": "+1234567890",
  "verified": false,
  "isEmailVerified": true,
  "blockedUsers": [],
  "preferences": {
    "darkMode": true,
    "notificationsEnabled": true,
    "emailNotifications": false,
    "language": "en",
    "autoPlayVideos": true,
    "compressMediaOnUpload": true
  }
}
```

### Local Hive Cache

**Box Name:** `users`
**Adapter ID:** 1 (UserAdapter)

Same structure as Firestore, stored locally on device.

---

## 🔄 Three-Level Caching System

### Level 1: Firestore (Remote Database)

**Purpose:** Primary persistent storage
**Location:** Google Cloud Firestore
**Sync:** Real-time with all devices
**Persistence:** Permanent (unless deleted)

**When used:**
- Initial app load (network-first strategy)
- Profile page loads
- User searches/follow operations

### Level 2: Hive Cache (Local Database)

**Purpose:** Offline-first fallback
**Location:** Device encrypted storage
**Sync:** Automatic from Firestore
**Persistence:** Survives app restart

**When used:**
- Network fails to fetch from Firestore
- App starts before network available
- Offline browsing

### Level 3: Image Cache (HTTP Cache)

**Purpose:** Fast image display
**Implementation:** `CachedNetworkImage`
**Location:** Device HTTP cache
**Persistence:** Temporary (configurable expiry)

**When used:**
- Image display in UI
- Avatar loaded on profile page
- Banner displayed on profile

---

## 🔀 Network-First Strategy with Fallback

```
Try Firestore (Network)
  ├─ Success → Cache to Hive → Display
  ├─ Uses latest data
  └─ User always online

Fallback to Hive (Local Cache)
  ├─ Firestore failed/slow
  ├─ Display cached data
  └─ Better UX than blank screen

Final Fallback
  ├─ No Hive cache
  └─ Show error message
```

---

## 💾 Data Persistence Architecture

### After Avatar Upload

```
Cloudinary URL
    ↓
UserRepository.updateUserAvatarUrl()
    ↓
┌─────────────────────────┐
│  Firestore Update       │ ✅ Persistent
│  users/{userId}         │    Syncs to all devices
│  avatar = url           │    Real-time
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  Hive Cache Update      │ ✅ Offline
│  UserBox.saveUser()     │    Fast fallback
│  avatar = url           │    Local storage
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  Riverpod State Update  │ ✅ In-Memory
│  ProfileEditState       │    Instant UI update
│  user.avatar = url      │    Survives state notifier
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  Image Cache            │ ✅ HTTP Cache
│  CachedNetworkImage     │    Fast future loads
│  avatar_url_image.jpg   │    Expires over time
└─────────────────────────┘
```

---

## 🎯 Code Implementation Details

### 1. Repository Layer (Domain Interface)

**File:** `lib/domain/repositories/user_repository.dart`

```dart
abstract class UserRepository {
  // Update avatar URL in database
  Future<User> updateUserAvatarUrl({
    required String userId,
    required String avatarUrl,
  });

  // Update banner URL in database
  Future<User> updateUserBannerUrl({
    required String userId,
    required String bannerUrl,
  });
}
```

### 2. Repository Implementation

**File:** `lib/data/repositories/user_repository_impl.dart`

```dart
@override
Future<User> updateUserAvatarUrl({
  required String userId,
  required String avatarUrl,
}) async {
  try {
    // 1. Update Firestore
    final updatedUser = await _usersApi.updateUserAvatarUrl(
      userId: userId,
      avatarUrl: avatarUrl,
    );

    // 2. Update Hive cache
    await _userBox.saveUser(updatedUser);

    // 3. Return updated user for state
    return updatedUser.toEntity();
  } catch (e) {
    _logger.e('Error updating avatar URL: $e');
    rethrow;
  }
}
```

### 3. API Layer (Firestore Operations)

**File:** `lib/data/datasources/remote/rest_api/users_api.dart`

```dart
Future<UserModel> updateUserAvatarUrl({
  required String userId,
  required String avatarUrl,
}) async {
  try {
    // Update Firestore document
    await _firestore
        .collection('users')
        .doc(userId)
        .update({
      'avatar': avatarUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Return updated user
    return await getUserById(userId);
  } catch (e) {
    _logger.e('Error updating avatar URL: $e');
    rethrow;
  }
}
```

### 4. Provider Layer (State Management)

**File:** `lib/presentation/features/profile/providers/profile_edit_provider.dart`

```dart
Future<bool> uploadAvatar(XFile imageFile) async {
  try {
    // Step 1: Upload to Cloudinary
    final avatarUrl = await _ref
        .read(cloudinary.cloudinaryUploadProvider.notifier)
        .uploadAvatar(imageFile.path);

    // Step 2: Save URL to database and cache
    final updatedUser = await _userRepository.updateUserAvatarUrl(
      userId: userId,
      avatarUrl: avatarUrl,
    );

    // Step 3: Update local state
    state = state.copyWith(
      user: updatedUser,
      successMessage: 'Avatar updated successfully',
    );

    return true;
  } catch (e) {
    state = state.copyWith(error: e.toString());
    return false;
  }
}
```

---

## 🔍 Verification Checklist

After uploading an avatar, verify data persistence:

### Immediate Check (In-App)
- [ ] Avatar displays in Edit Profile page
- [ ] Success message shows "Avatar updated successfully"
- [ ] No error messages appear

### Hive Cache Check (Local Storage)
```dart
// In debug console
final userBox = await Hive.openBox<UserModel>('users');
final cachedUser = await userBox.get(userId);
print('Cached avatar URL: ${cachedUser?.avatar}');
```

### Firestore Check (Remote Database)
1. Go to Firebase Console
2. Go to Firestore Database
3. Navigate to `users` collection
4. Open your user document
5. Check `avatar` field contains Cloudinary URL

### CachedNetworkImage Check (HTTP Cache)
1. Navigate away from profile page
2. Come back to profile page
3. Avatar should load instantly (from cache)

---

## ⚡ Performance Optimization

### Initial Load (First Time)
```
Network fetch from Firestore (500-2000ms)
  ↓
Save to Hive cache (50-100ms)
  ↓
Display from Hive (instant)
  ↓
Fetch image from Cloudinary (500-1500ms)
  ↓
Cache image locally (100-500ms)
  ↓
Display high-quality image
```

### Subsequent Loads (Cached)
```
Load from Hive cache (instant <5ms)
  ↓
Display user data instantly
  ↓
Load image from HTTP cache (fast <50ms)
  ↓
Display avatar with no delay
```

---

## 🔐 Data Consistency

### How Consistency is Maintained

1. **Write-Through Pattern**
   - Write to Firestore first
   - Then update Hive cache
   - Ensures Hive never has stale data

2. **Network-First Strategy**
   - Always try Firestore first
   - Fallback to Hive if offline
   - Keeps data in sync when online

3. **Automatic Timestamp**
   - `updatedAt` set on every update
   - Tracks when data was last modified
   - Useful for sync conflicts

4. **Single Source of Truth**
   - Firestore is authoritative
   - Hive is a copy/cache
   - Data flows: Firestore → Hive

---

## 🚨 Error Handling

### Network Error (Firestore Update Fails)

```dart
try {
  await firestore.update(...);
} catch (e) {
  _logger.e('Firestore update failed: $e');
  rethrow; // Show error to user
}
```

**User Experience:**
- Error message displayed
- Local state not updated
- User can retry upload
- No partial data saved

### Partial Update (One Layer Fails)

```dart
// Update Firestore
final updated = await _api.updateUserAvatarUrl(...);

// Update cache (best-effort, don't fail if it breaks)
try {
  await _userBox.saveUser(updated);
} catch (e) {
  _logger.w('Cache update failed: $e');
  // Don't rethrow - Firestore update succeeded
}
```

**User Experience:**
- Firestore update succeeds
- Data persists
- Cache might be outdated
- Next sync will fix it

---

## 📱 Offline Usage

### While Offline
1. Can view cached avatars/banners
2. Cannot upload new images (needs Cloudinary API)
3. Cannot update profile (needs Firestore)

### When Connection Returns
1. Hive cache used for immediate display
2. Firestore fetched to check for updates
3. Any new remote updates displayed

---

## 🔄 Real-Time Sync Example

### Multi-Device Sync

```
Device A (Your phone)
  │
  ├─→ Upload avatar to Cloudinary
  ├─→ Save URL to Firestore ✅
  └─→ Update Hive cache ✅

Firestore (Realtime Database)
  │
  ├─→ Avatar field updated
  └─→ Notifies all listening clients

Device B (Friend's device viewing your profile)
  │
  └─→ Receives Firestore update ✅
      Shows new avatar immediately
```

---

## 🎯 Common Scenarios

### Scenario 1: Upload Avatar → App Closes → Restart

**What happens:**
1. Upload to Cloudinary ✅ (URL obtained)
2. Update Firestore ✅ (URL saved)
3. Update Hive ✅ (cached)
4. App closes
5. App restarts
6. Load user profile
7. Check Hive cache first (fast)
8. Avatar displays immediately ✅

**Result:** Avatar persists across app restart

### Scenario 2: Offline Upload Attempt

**What happens:**
1. User tries to upload avatar
2. Cloudinary upload fails (no network)
3. Error shown to user
4. Hive cache not updated
5. User can retry when online

**Result:** Safe error handling, no partial data

### Scenario 3: Slow Network

**What happens:**
1. Upload to Cloudinary (takes 5 seconds)
2. Firestore update (takes 2 seconds)
3. Hive update (instant)
4. UI shows success immediately
5. Can navigate away safely
6. Data persists even if user closes app

**Result:** Responsive UI even with slow network

---

## 📊 Database Summary

| Layer | Technology | Purpose | Speed | Persistence |
|-------|-----------|---------|-------|-------------|
| Remote | Firestore | Source of truth | 500-2000ms | Permanent |
| Local | Hive | Offline cache | <5ms | Survives restart |
| Memory | Riverpod | UI state | Instant | Survives hot reload |
| HTTP Cache | Network | Image cache | <50ms | Temporary |

---

## 🚀 Next Steps

After implementing database persistence:

1. **Test Avatar Upload**
   - Upload new avatar
   - Check Firestore has URL
   - Close and restart app
   - Verify avatar persists

2. **Test Banner Upload**
   - Same process as avatar
   - Verify banner persists

3. **Test Offline Scenario**
   - Turn off network
   - Navigate to profile
   - Avatar should load from Hive cache

4. **Monitor Logs**
   - Check console for "Avatar URL updated successfully"
   - Watch for any errors

---

**Status:** ✅ Database persistence fully implemented!

The avatar/banner uploads are now saved to Firestore and cached locally. On app restart, your profile images will load from the database.

---

*Updated: November 21, 2024*
*Version: 1.0.0*

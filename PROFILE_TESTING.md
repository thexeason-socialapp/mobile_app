# Profile Feature Testing Guide

## Overview
The profile feature has been fully implemented with responsive design for all screen sizes (mobile, tablet, desktop, web). This guide will help you test the profile functionality.

## What's Been Implemented

### 1. **Data Layer**
- ✅ `UsersApi` - Firestore API for user operations (get, update, follow/unfollow, etc.)
- ✅ `UserBox` - Hive local storage for offline caching
- ✅ `UserAdapter` & `UserPreferencesAdapter` - Hive type adapters for serialization
- ✅ `UserRepositoryImpl` - Repository with network-first + cache fallback strategy

### 2. **State Management**
- ✅ `ProfileStateProvider` - Riverpod state notifier for profile management
- ✅ Auto-loads profile data when provider is created
- ✅ Optimistic updates for follow/unfollow actions
- ✅ Determines if viewing own profile vs another user's profile

### 3. **UI Components**
- ✅ `ProfilePage` - Main profile page with tabs (Posts, Media, Likes)
- ✅ `ProfileHeader` - Banner, avatar, user info with 3 responsive layouts
- ✅ `ProfileStats` - Posts, followers, following counts
- ✅ `AvatarWidget` - Circular avatar with edit overlay for own profile
- ✅ `FollowButton` - Follow/Following states with loading indicator

### 4. **Utilities**
- ✅ `ImageHelper` - Image picker with camera/gallery support and validation

### 5. **Dependency Injection**
- ✅ All providers registered in `lib/core/di/providers.dart`
- ✅ Hive adapters initialized in `main.dart`

### 6. **Routing**
- ✅ `/profile` - View your own profile (uses current user ID from auth state)
- ✅ `/user/:userId` - View another user's profile by ID

## How to Test

### Prerequisites
1. Ensure Firebase is properly configured
2. Have at least one user account created
3. Make sure you're logged in

### Testing Steps

#### 1. **View Your Own Profile**
```bash
# Navigate in the app: Bottom navigation > Profile tab
# OR use the route directly
context.go('/profile');
```

**What to check:**
- ✅ Profile loads with your user data
- ✅ Avatar displays (or shows initials if no avatar)
- ✅ Banner displays (or shows gradient placeholder)
- ✅ Display name, username, bio appear correctly
- ✅ Stats show: Posts count, Followers count, Following count
- ✅ "Edit Profile" button appears
- ✅ Settings icon in app bar
- ✅ Pull-to-refresh works

#### 2. **View Another User's Profile**
```bash
# Navigate programmatically or via deep link
context.go('/user/SOME_USER_ID');
```

**What to check:**
- ✅ Profile loads with other user's data
- ✅ "Follow" or "Following" button appears (not "Edit Profile")
- ✅ Can tap Follow to follow the user
- ✅ Button changes to "Following" after successful follow
- ✅ Stats update optimistically when following/unfollowing
- ✅ Menu button (3 dots) shows: Share, Block, Report options

#### 3. **Responsive Design Testing**
Test on different screen sizes:

**Mobile (< 768px):**
- ✅ Vertical layout
- ✅ 80px avatar
- ✅ 180px banner height
- ✅ Centered text alignment

**Tablet (768-1024px):**
- ✅ More spacious layout
- ✅ 100px avatar
- ✅ 220px banner height

**Desktop (> 1024px):**
- ✅ Horizontal info layout
- ✅ 120px avatar
- ✅ 280px banner height
- ✅ Left-aligned text

#### 4. **Error Handling**
Test error scenarios:

**No internet:**
- ✅ Should load cached profile if available
- ✅ Shows error message if no cache

**Invalid user ID:**
- ✅ Shows error state with retry button

**Empty profile:**
- ✅ Shows "User not found" message

#### 5. **Loading States**
- ✅ Shows circular progress indicator while loading
- ✅ Follow button shows spinner during follow/unfollow

#### 6. **Tabs (Currently Placeholders)**
- Posts tab - Shows placeholder "Posts will appear here"
- Media tab - Shows placeholder "Media will appear here"
- Likes tab - Shows placeholder (private for others, or your likes if own profile)

## Known Limitations / TODO

### Not Yet Implemented:
1. **Edit Profile Page** - Button exists but shows "Coming Soon" snackbar
2. **Posts/Media/Likes Content** - Tabs show placeholders
3. **Followers/Following Pages** - Shows "Coming Soon" snackbar
4. **Image Upload** - Avatar/banner editing not wired up yet
5. **Block/Report Features** - Shows "Coming Soon" snackbar
6. **Share Profile** - Shows "Coming Soon" snackbar
7. **Settings Page** - Not fully implemented

### Temporary Workarounds:
- `currentUserProvider` in `profile_state_provider.dart` is temporary
  - Should be moved to a centralized auth provider file
  - Currently returns null, needs to be connected to actual auth state

## Firestore Data Structure Expected

The profile feature expects users to be stored in Firestore with this structure:

```json
{
  "users": {
    "userId123": {
      "email": "user@example.com",
      "username": "johndoe",
      "displayName": "John Doe",
      "bio": "Software engineer and coffee enthusiast",
      "avatar": "https://firebase.storage.url/avatars/...",
      "banner": "https://firebase.storage.url/banners/...",
      "followers": 150,
      "following": 200,
      "postsCount": 42,
      "createdAt": "2025-01-15T10:30:00Z",
      "updatedAt": "2025-01-18T15:45:00Z",
      "isPrivate": false,
      "location": "San Francisco, CA",
      "website": "https://johndoe.com",
      "phone": null,
      "verified": false,
      "isEmailVerified": true,
      "blockedUsers": [],
      "preferences": {
        "darkMode": false,
        "notificationsEnabled": true,
        "emailNotifications": true,
        "language": "en",
        "autoPlayVideos": true,
        "compressMediaOnUpload": true
      }
    }
  },
  "followers": {
    "userId123": {
      "followerId1": true,
      "followerId2": true
    }
  },
  "following": {
    "userId123": {
      "followingId1": true,
      "followingId2": true
    }
  }
}
```

## Testing Without Real Data

If you don't have real user data in Firestore yet, you can:

1. **Create test users manually in Firebase Console**
2. **Use the signup flow** to create test accounts
3. **Populate Firestore with sample data** using Firebase Admin SDK or Console

## Running the App

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on your device
flutter run

# Or for web
flutter run -d chrome
```

## Debugging Tips

1. **Check Firebase connection:**
   - Look for "✅ Firebase initialized successfully" in console logs

2. **Check Hive initialization:**
   - Look for "✅ Hive initialized successfully" in console logs

3. **Monitor profile loading:**
   - Profile state provider logs loading states
   - Check Firestore rules allow read access to user documents

4. **Network errors:**
   - Ensure Firestore rules permit reading user documents
   - Check internet connection
   - Verify Firebase project configuration

## Next Steps

To complete the profile feature:
1. Implement Edit Profile page with image upload
2. Build Posts/Media/Likes tab content
3. Create Followers/Following list pages
4. Add Block/Report functionality
5. Implement Share profile feature
6. Connect to actual posts when Post feature is built
7. Add profile analytics/insights
8. Implement profile caching strategy
9. Add profile deep linking
10. Create profile onboarding flow for new users

---

**Status:** ✅ Profile viewing is complete and ready for testing!
**Last Updated:** 2025-01-18

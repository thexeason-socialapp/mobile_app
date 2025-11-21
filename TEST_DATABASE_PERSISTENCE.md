# 🧪 Testing Database Persistence

Quick guide to verify avatar/banner uploads are saved to database and cache.

---

## ✅ Test 1: Upload Avatar & Verify Firestore

**Time:** 5 minutes

### Steps

1. **Open your app**
   ```bash
   flutter run
   ```

2. **Go to Profile → Edit Profile**

3. **Tap on avatar image**

4. **Select an image from gallery**

5. **Wait for upload to complete**
   - You should see success message: "Avatar updated successfully"
   - Avatar should display in the Edit Profile page

6. **Check Firestore Console**
   - Go to Firebase Console: https://console.firebase.google.com
   - Select your TheXeason project
   - Go to Firestore Database
   - Navigate to `users` collection
   - Click your user document
   - Look for `avatar` field
   - **Should contain:** URL starting with `https://res.cloudinary.com/`

### Expected Result
✅ Avatar field in Firestore contains Cloudinary URL

---

## ✅ Test 2: Restart App & Verify Persistence

**Time:** 5 minutes

### Steps

1. **After successful avatar upload (from Test 1)**

2. **Close the app completely**
   - Swipe up (iOS) or back button (Android) to fully close

3. **Restart the app**
   ```bash
   flutter run
   ```

4. **Navigate to Profile → Edit Profile**

5. **Look at the avatar**
   - **Should see:** Your uploaded avatar image
   - **Should NOT see:** Placeholder or old image

6. **Check the logs**
   - Should see: "Loading from Hive cache" or similar
   - Then: Avatar URL loaded from cache

### Expected Result
✅ Avatar persists after app restart (loaded from Hive cache)

---

## ✅ Test 3: Verify Hive Cache

**Time:** 5 minutes (development only)

### Steps

1. **Open Flutter console**
   - In VSCode, look for "Debug Console" or terminal running `flutter run`

2. **Add debugging to see cache**
   - In `lib/presentation/features/profile/pages/profile_page.dart`, add:
   ```dart
   // Inside build method or initState
   Future<void> _debugPrintCache() async {
     try {
       final box = await Hive.openBox<UserModel>('users');
       final cachedUser = await box.get(userId);
       print('📦 Cached avatar URL: ${cachedUser?.avatar}');
       print('📦 Cached banner URL: ${cachedUser?.banner}');
     } catch (e) {
       print('❌ Cache error: $e');
     }
   }
   ```

3. **Call this method after profile loads**
   - Should print avatar and banner URLs

### Expected Result
✅ Hive cache contains Cloudinary URLs

---

## ✅ Test 4: Offline Loading (Optional)

**Time:** 10 minutes

### Steps

1. **Upload avatar successfully (Test 1)**

2. **Turn off network**
   - Airplane mode ON (iOS/Android)
   - Or disable Wi-Fi

3. **Restart the app** (while offline)
   ```bash
   flutter run
   ```

4. **Go to Profile page**
   - **Should see:** Avatar loaded from Hive cache
   - **Should NOT see:** Error message
   - **Should NOT see:** Loading spinner forever

5. **Check console**
   - Should show fallback to Hive cache
   - No errors about network

6. **Turn network back on**
   - Airplane mode OFF
   - Network should reconnect

### Expected Result
✅ Avatar loads from local cache even when offline

---

## ✅ Test 5: Banner Upload

**Time:** 5 minutes

### Steps

Repeat Test 1-2 for banner:

1. **In Profile Edit page**
   - Tap on banner area

2. **Select image and upload**
   - Wait for success message

3. **Check Firestore**
   - `banner` field should have Cloudinary URL

4. **Restart app**
   - Banner should persist

### Expected Result
✅ Banner works same as avatar

---

## ✅ Test 6: Image Caching (CachedNetworkImage)

**Time:** 10 minutes

### Steps

1. **Upload avatar successfully**

2. **Check network speed**
   - Note how long avatar takes to load first time

3. **Navigate away from profile**
   - Go to Feed or Messages

4. **Navigate back to Profile**
   - Avatar should load instantly
   - Should NOT need to download again

5. **Check files on device** (Optional)
   - Avatar image should be cached locally
   - Location: `/data/data/com.example.thexeasonapp/cache/image_cache/`

### Expected Result
✅ Second load is much faster (image cached)

---

## 🔍 Troubleshooting

### Problem: Avatar not saving to Firestore

**Debug:**
1. Check console for errors
2. Verify Cloudinary URL returned
3. Check Firestore rules allow `users/{userId}` update
4. Check user ID is correct

**Solution:**
- Check `users_api.dart` error handling
- Verify Firestore collection permissions
- Check user is authenticated

### Problem: Avatar not persisting after restart

**Debug:**
1. Check Hive box is created
2. Verify `UserAdapter` is registered
3. Check Hive file permissions

**Solution:**
- Ensure `UserAdapter` in `user_adapter.dart` is properly registered
- Check `main.dart` initializes Hive correctly
- Verify box name is `'users'`

### Problem: Avatar loads slow on second load

**Debug:**
1. Check `CachedNetworkImage` cache duration
2. Verify HTTP cache not clearing
3. Check network/image size

**Solution:**
- Image may be too large
- Check Cloudinary transformations optimize size
- Verify network is good

### Problem: Offline mode doesn't work

**Debug:**
1. Check Hive cache has data
2. Verify app doesn't crash
3. Check error handling

**Solution:**
- Ensure Hive cache was updated
- Check network error handling doesn't crash app
- Verify fallback logic in `user_repository_impl.dart`

---

## 📊 Expected Console Output

### After Successful Avatar Upload

```
✅ Uploading file to Cloudinary: avatars/avatar_[timestamp]
📤 Upload progress: 25%
📤 Upload progress: 50%
📤 Upload progress: 75%
✅ Upload complete!
🔗 URL: https://res.cloudinary.com/dcwlprnaa/image/upload/.../avatar_xxx
ℹ️ Updating avatar URL for user: user123
✅ Avatar URL updated successfully for user: user123
```

### After App Restart

```
ℹ️ Fetching user by ID: user123
ℹ️ Network fetch failed, trying local cache: SocketException...
ℹ️ Returning cached user data for: user123
📦 Cached avatar URL: https://res.cloudinary.com/dcwlprnaa/image/upload/.../avatar_xxx
```

---

## ✅ Final Verification Checklist

- [ ] Avatar uploads to Cloudinary (gets URL)
- [ ] Avatar URL saved to Firestore
- [ ] Avatar URL saved to Hive cache
- [ ] Avatar persists after app restart
- [ ] Avatar loads from cache on second visit
- [ ] Avatar loads offline (from cache)
- [ ] Banner works same as avatar
- [ ] No error messages in console
- [ ] Success message shows on upload
- [ ] Firestore console shows avatar URL

---

## 🎯 You're Done!

If all tests pass, your database persistence is working correctly!

**Next steps:**
1. Test post image uploads (use same logic)
2. Monitor usage in Firestore
3. Optimize image sizes if needed
4. Deploy to production

---

**Created:** November 21, 2024
**Version:** 1.0.0

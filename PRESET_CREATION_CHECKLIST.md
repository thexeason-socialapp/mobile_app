# ✅ Preset Creation Checklist

**Quick Reference While Creating Presets**

---

## 🔗 Link to Dashboard
https://cloudinary.com/console/c/dcwlprnaa/settings/upload

---

## Preset 1️⃣: user_avatars

- [ ] Click "Add upload preset"
- [ ] **Preset Name:** `user_avatars`
- [ ] **Mode:** `Unsigned` ✅ (CRITICAL!)
- [ ] **Folder:** `users/avatars`
- [ ] **Max file size:** `5` MB
- [ ] **Allowed formats:** `jpg, jpeg, png, webp`
- [ ] **Transformation:** `c_fill,w_400,h_400,g_face,q_auto,f_auto`
- [ ] Click **Save**

---

## Preset 2️⃣: post_images

- [ ] Click "Add upload preset"
- [ ] **Preset Name:** `post_images`
- [ ] **Mode:** `Unsigned` ✅
- [ ] **Folder:** `posts/media`
- [ ] **Max file size:** `10` MB
- [ ] **Allowed formats:** `jpg, jpeg, png, webp, gif`
- [ ] **Transformation:** `c_limit,w_1080,q_auto,f_auto`
- [ ] Click **Save**

---

## Preset 3️⃣: post_videos

- [ ] Click "Add upload preset"
- [ ] **Preset Name:** `post_videos`
- [ ] **Mode:** `Unsigned` ✅
- [ ] **Folder:** `posts/videos`
- [ ] **Max file size:** `100` MB
- [ ] **Allowed formats:** `mp4, mov, avi, mkv, flv, wmv`
- [ ] **Transformation:** `q_auto,f_auto,c_scale,w_720`
- [ ] Click **Save**

---

## Preset 4️⃣: voice_notes

- [ ] Click "Add upload preset"
- [ ] **Preset Name:** `voice_notes`
- [ ] **Mode:** `Unsigned` ✅
- [ ] **Folder:** `messages/voice`
- [ ] **Max file size:** `10` MB
- [ ] **Allowed formats:** `mp3, m4a, wav, aac, flac`
- [ ] **Transformation:** (leave empty)
- [ ] Click **Save**

---

## Preset 5️⃣: user_banners

- [ ] Click "Add upload preset"
- [ ] **Preset Name:** `user_banners`
- [ ] **Mode:** `Unsigned` ✅
- [ ] **Folder:** `users/banners`
- [ ] **Max file size:** `10` MB
- [ ] **Allowed formats:** `jpg, jpeg, png, webp`
- [ ] **Transformation:** `c_limit,w_1200,q_auto,f_auto`
- [ ] Click **Save**

---

## ❓ Where is File Size?

**If you can't find "Max file size":**

1. Look in **"Upload Settings"** section (most common)
2. Or look under **"Advanced"** / **"More options"**
3. Or check **Settings > Security > Upload restrictions**

**Don't worry if you can't find it!** Your app validates file sizes anyway. You can skip setting it in Cloudinary.

---

## ✅ Final Check

After creating all presets:

- [ ] Preset 1: `user_avatars` exists
- [ ] Preset 2: `post_images` exists
- [ ] Preset 3: `post_videos` exists
- [ ] Preset 4: `voice_notes` exists
- [ ] Preset 5: `user_banners` exists
- [ ] All 5 have Mode: **Unsigned** ✅
- [ ] All 5 are saved

---

## 🚀 Next: Test the App

Once presets are created:

1. Run `flutter run`
2. Go to Profile > Edit
3. Upload an avatar image
4. Verify it works!

See `CLOUDINARY_TESTING_GUIDE.md` for full testing steps.

---

**Duration:** ~5-10 minutes to create all 5 presets


# ⚡ Quick Start: Cloudinary in 5 Minutes

Get your TheXeason app uploading images to Cloudinary in under 5 minutes!

---

## Step 1: Sign Up (2 minutes)
1. Go to https://cloudinary.com/users/register
2. Sign up with email or Google
3. Verify your email
4. Done!

---

## Step 2: Get Credentials (1 minute)

### Find Cloud Name
- In dashboard, look at top-right
- You'll see: "Cloud name: **dxyz123abc**"
- Copy it

### Find API Key
- Click "Settings" → "API Key"
- Copy "API Key" value

### Find API Secret
- Same Settings → API Key page
- Copy "API Secret" (long string)

---

## Step 3: Update .env (1 minute)

Open: `c:\flutterprojects\thexeasonapp\thexeasonapp\.env`

Replace placeholder values:

```env
CLOUDINARY_CLOUD_NAME=dxyz123abc
CLOUDINARY_API_KEY=123456789012345
CLOUDINARY_API_SECRET=aB1cD2eF3gH4iJ5kL6mN7oP8qR9sT0uV
STORAGE_PROVIDER=cloudinary
```

Save file!

---

## Step 4: Restart App (1 minute)

```bash
flutter run
```

---

## Step 5: Test Upload (1 minute)

1. Open app
2. Go to Feed
3. Tap yellow **+** button
4. Select image
5. Tap **Post**
6. See your image appear! ✅

---

## That's It! 🎉

Your app now uploads to Cloudinary with:
- ✅ Automatic image compression
- ✅ Face-aware cropping
- ✅ Responsive images
- ✅ Zero egress fees
- ✅ Global CDN

---

## Verify It Worked

1. Open Cloudinary dashboard
2. Click "Media Library"
3. See your image there
4. Click to view details
5. Try opening the URL in browser

---

## If It Doesn't Work

**Check 1:** Did you copy credentials correctly?
- No extra spaces
- Match exactly from dashboard

**Check 2:** Did you restart the app?
- Close app completely
- Run `flutter run` again

**Check 3:** Check console logs
- Look for error message
- Copy error text
- Reference docs: CLOUDINARY_SETUP_GUIDE.md

---

## Free Tier Includes

- 📦 25GB storage
- 🌐 Global CDN
- 🎨 Image optimization
- 🎬 Video support
- 📱 Responsive images
- 👤 Face detection
- ♾️ Zero egress fees

Perfect for MVP! 🚀

---

## Next Features to Try

- Upload multiple images (up to 4)
- Create posts with mix of text + images
- Try video upload
- Check Media Library in Cloudinary dashboard

---

**Done!** You're using Cloudinary 🎉

For detailed guide: See `CLOUDINARY_SETUP_GUIDE.md`

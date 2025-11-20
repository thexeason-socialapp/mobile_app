# Cloudflare R2 Setup Guide

Complete step-by-step guide to set up Cloudflare R2 for TheXeason App.

---

## Step 1: Create Cloudflare Account

### 1.1 Sign Up
1. Go to https://dash.cloudflare.com/sign-up
2. Enter your email address
3. Create a strong password
4. Verify your email address

### 1.2 Skip Domain Setup (Optional)
- If prompted to add a domain, you can skip this for now
- We only need R2 storage, not full Cloudflare DNS/CDN services

---

## Step 2: Enable R2 Storage

### 2.1 Navigate to R2
1. Log into Cloudflare Dashboard: https://dash.cloudflare.com
2. In the left sidebar, click **"R2"** under "Storage & Databases"
3. Or go directly to: https://dash.cloudflare.com/?to=/:account/r2

### 2.2 Enable R2 (First Time Only)
1. Click **"Get Started"** or **"Enable R2"**
2. You may need to:
   - Accept terms of service
   - Add a payment method (required, but has generous free tier)

### 2.3 R2 Pricing (As of 2024)
**Free Tier Includes:**
- ✅ 10 GB storage per month
- ✅ 1 million Class A operations (writes)
- ✅ 10 million Class B operations (reads)
- ✅ **Zero egress fees** (unlimited free downloads)

**Paid Tier (if you exceed free tier):**
- $0.015 per GB stored per month
- Still **zero egress fees**

This is perfect for a social media app - you'll likely stay in free tier during development!

---

## Step 3: Create R2 Bucket

### 3.1 Create New Bucket
1. In R2 dashboard, click **"Create bucket"**
2. Enter bucket details:
   - **Bucket name**: `thexeason-media` (lowercase, no spaces)
   - **Location**: Choose closest to your users
     - **Automatic** (recommended) - Cloudflare chooses best location
     - Or select specific region (e.g., North America, Europe, Asia-Pacific)

3. Click **"Create bucket"**

### 3.2 Configure Bucket Settings

#### Enable Public Access (Important!)
1. Click on your newly created bucket (`thexeason-media`)
2. Go to **"Settings"** tab
3. Scroll to **"Public access"** section
4. Click **"Allow Access"** or **"Connect Domain"**

**Option A: R2.dev Subdomain (Quick Start)**
1. Click **"Allow Access"**
2. Cloudflare will provide a public URL like:
   ```
   https://pub-abc123def456.r2.dev
   ```
3. Save this URL - you'll need it for `.env` file

**Option B: Custom Domain (Production Ready)**
1. Click **"Connect Domain"**
2. Enter your domain (e.g., `media.thexeason.com`)
3. Follow DNS setup instructions
4. More professional, but requires domain ownership

**Recommendation:** Use Option A (R2.dev) for now, switch to custom domain later.

---

## Step 4: Generate API Tokens

### 4.1 Create R2 API Token
1. In R2 dashboard, click **"Manage R2 API Tokens"** in top right
2. Or go to: https://dash.cloudflare.com/?to=/:account/r2/api-tokens
3. Click **"Create API token"**

### 4.2 Configure Token Permissions
1. **Token name**: `thexeason-app-token` (or any descriptive name)
2. **Permissions**:
   - ✅ Object Read & Write
   - ✅ (Ensure it has access to your bucket)
3. **Bucket scope**:
   - Select **"Apply to specific buckets only"**
   - Choose: `thexeason-media`
4. **TTL (Time to Live)**: Forever (or set expiry if needed)
5. Click **"Create API Token"**

### 4.3 Save Credentials (IMPORTANT!)
After creating the token, you'll see:

```
Access Key ID: abc123def456ghi789
Secret Access Key: XyZ123AbC456DeF789GhI012JkL345MnO678PqR
```

⚠️ **CRITICAL**: Save these credentials immediately!
- You'll only see the Secret Access Key **once**
- Copy both to a secure location (password manager recommended)
- We'll use these in the `.env` file

### 4.4 Get Account ID
1. In Cloudflare dashboard, scroll to the bottom right
2. You'll see **"Account ID"**: `a1b2c3d4e5f6g7h8i9j0`
3. Copy this - you'll need it for the R2 endpoint URL

---

## Step 5: Configure Environment Variables

### 5.1 Create `.env` File
In your project root, create a file named `.env`:

```bash
# .env (in project root: c:\flutterprojects\thexeasonapp\thexeasonapp\.env)

# Cloudflare R2 Configuration
CLOUDFLARE_R2_ACCESS_KEY=YOUR_ACCESS_KEY_ID_HERE
CLOUDFLARE_R2_SECRET_KEY=YOUR_SECRET_ACCESS_KEY_HERE
CLOUDFLARE_R2_BUCKET_NAME=thexeason-media
CLOUDFLARE_R2_ACCOUNT_ID=YOUR_ACCOUNT_ID_HERE
CLOUDFLARE_R2_ENDPOINT=https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com
CLOUDFLARE_R2_PUBLIC_URL=https://pub-abc123def456.r2.dev
```

### 5.2 Fill in Your Values
Replace the following with your actual values:
- `YOUR_ACCESS_KEY_ID_HERE` → Access Key ID from Step 4.3
- `YOUR_SECRET_ACCESS_KEY_HERE` → Secret Access Key from Step 4.3
- `YOUR_ACCOUNT_ID_HERE` → Account ID from Step 4.4
- `https://pub-abc123def456.r2.dev` → Public URL from Step 3.2

**Example (with fake credentials):**
```bash
CLOUDFLARE_R2_ACCESS_KEY=9a8b7c6d5e4f3g2h1i0j
CLOUDFLARE_R2_SECRET_KEY=Z1Y2X3W4V5U6T7S8R9Q0P1O2N3M4L5K6J7I8H9G0
CLOUDFLARE_R2_BUCKET_NAME=thexeason-media
CLOUDFLARE_R2_ACCOUNT_ID=a1b2c3d4e5f6g7h8i9j0
CLOUDFLARE_R2_ENDPOINT=https://a1b2c3d4e5f6g7h8i9j0.r2.cloudflarestorage.com
CLOUDFLARE_R2_PUBLIC_URL=https://pub-abc123def456.r2.dev
```

### 5.3 Add `.env` to `.gitignore`
**CRITICAL FOR SECURITY**: Never commit `.env` to Git!

Add this line to `.gitignore`:
```
# Environment variables
.env
```

---

## Step 6: Verify R2 Setup

### 6.1 Test Bucket Access
You can test your bucket in Cloudflare dashboard:

1. Go to R2 → Your bucket (`thexeason-media`)
2. Click **"Upload"**
3. Upload a test image
4. Click on the uploaded file
5. Copy the public URL
6. Open URL in browser - you should see your image

### 6.2 Check Public Access
If the image URL works, your bucket is correctly configured for public access!

---

## Step 7: Summary of What You Have Now

After completing all steps, you should have:

✅ Cloudflare account created
✅ R2 storage enabled
✅ Bucket `thexeason-media` created
✅ Public access enabled (R2.dev URL)
✅ API token created with Read/Write permissions
✅ `.env` file configured with all credentials
✅ `.env` added to `.gitignore`

---

## Quick Reference Card

Save this information securely:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CLOUDFLARE R2 CREDENTIALS (THEXEASON APP)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Account ID:        a1b2c3d4e5f6g7h8i9j0
Bucket Name:       thexeason-media
Access Key ID:     9a8b7c6d5e4f3g2h1i0j
Secret Access Key: Z1Y2X3W4V5U6T7S8R9Q0P1O2N3M4L5K6J7I8H9G0
Endpoint:          https://a1b2c3d4e5f6g7h8i9j0.r2.cloudflarestorage.com
Public URL:        https://pub-abc123def456.r2.dev

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Troubleshooting

### Issue: "Access Denied" when uploading
**Solution**:
- Verify API token has "Object Read & Write" permissions
- Check token is scoped to correct bucket

### Issue: "Bucket not found"
**Solution**:
- Verify bucket name matches exactly (case-sensitive)
- Ensure Account ID is correct in endpoint URL

### Issue: Public URL returns 404
**Solution**:
- Ensure public access is enabled in bucket settings
- Verify the file was uploaded successfully
- Check the public URL format is correct

### Issue: Can't enable R2
**Solution**:
- Add payment method (even for free tier)
- Verify email address
- Contact Cloudflare support if issue persists

---

## Next Steps

Once you've completed this setup:

1. ✅ Verify `.env` file has all correct values
2. ✅ Test bucket access by uploading a file in dashboard
3. ✅ Notify me that setup is complete
4. 🚀 I'll implement the storage integration code

---

## Useful Links

- **R2 Dashboard**: https://dash.cloudflare.com/?to=/:account/r2
- **R2 Documentation**: https://developers.cloudflare.com/r2/
- **API Reference**: https://developers.cloudflare.com/r2/api/s3/api/
- **Pricing Details**: https://developers.cloudflare.com/r2/pricing/
- **Support**: https://community.cloudflare.com/

---

**Estimated Setup Time**: 15-20 minutes

**Cost**: $0 (free tier covers development needs)

**Need Help?** Let me know which step you're stuck on!

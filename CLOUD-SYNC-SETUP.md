# HollowNet Cloud Sync Setup

HollowNet can optionally share assets across browsers with a Supabase project.
Local browser storage remains enabled as a fallback.

## One-Time Setup

1. Create a Supabase project at <https://supabase.com>.
2. Open the Supabase SQL editor and run `supabase-setup.sql`.
3. In Supabase, open the project's **Connect** dialog or **Settings > API Keys**.
4. Copy the project URL and a **publishable** key. Do not use a secret or service-role key.
5. Open HollowNet, choose **Cloud Sync**, and enter:
   - Supabase project URL
   - Publishable key
   - A workspace ID such as `house-in-the-hollow`
   - A private workspace access code of at least 12 characters
6. Choose **Save Connection**, then **Push Local Assets** in the browser that already has your records.
7. In another browser, enter the same settings and choose **Pull Cloud Assets**.

## How It Works

- Asset changes continue to save locally in the current browser.
- After cloud sync is connected, saved changes are also pushed automatically.
- Pulling replaces that browser's local asset list with the cloud workspace.
- The database hashes the workspace access code and blocks direct table reads and writes.

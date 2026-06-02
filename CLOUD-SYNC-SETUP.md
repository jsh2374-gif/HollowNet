# HollowNet Cloud Sync Setup

HollowNet shares assets across browsers with a Supabase project. Viewing is automatic.
Local browser storage remains enabled as a fallback if Supabase is temporarily unavailable.

## One-Time Setup

1. Create a Supabase project at <https://supabase.com>.
2. Open the Supabase SQL editor and run `supabase-setup.sql`.
3. Open HollowNet, choose **Cloud Sync**, and create a private editing password of at least 12 characters.
4. Choose **Save Editing Password**, then **Push Local Assets** in the browser that already has your records.
5. Other browsers load the shared asset list automatically.
6. On another browser that should be allowed to make changes, enter the same editing password once.

## How It Works

- Shared assets load automatically when HollowNet opens.
- Anyone with the HollowNet URL can view the shared asset list.
- Adding, editing, copying, importing, deleting and clearing records require the editing password.
- Authorized changes continue to save locally and are also pushed automatically.
- The database hashes the workspace access code and blocks direct table reads and writes.

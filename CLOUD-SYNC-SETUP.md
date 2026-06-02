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

## Direct Media Uploads

Run the latest `supabase-setup.sql` again to add the `hollownet-media` Storage bucket.
It is safe to rerun the full setup file. The bucket accepts images and videos up to 50 MB.

In the asset editor, open **Documentation & Service**, choose **Upload Photos or Videos**,
then save the asset record. Uploaded media appears directly on the asset's QR page.

The bucket is public so scanned QR pages can display media without a login. The planner checks
the editing password before it uploads a file, but the browser-facing Storage upload route is
necessarily public for this static GitHub Pages version. Use the bucket only for attraction media
that is safe to publish, and monitor its storage usage in Supabase.

## Build Planner

`build-planner.html` is a companion page for projects that still need to be built.
It tracks build stage, progress, target dates, notes and material checklists.

Run the latest `supabase-setup.sql` again to add the shared build-list functions.
It uses the same HollowNet editing password as the asset planner.

## How It Works

- Shared assets load automatically when HollowNet opens.
- Anyone with the HollowNet URL can view the shared asset list.
- Adding, editing, copying, importing, deleting and clearing records require the editing password.
- Authorized changes continue to save locally and are also pushed automatically.
- The database hashes the workspace access code and blocks direct table reads and writes.
- Direct uploads are restricted to image and video MIME types, a 50 MB per-file maximum and the
  HollowNet workspace folder. Existing files cannot be overwritten through the browser upload policy.
- The build planner syncs separately from asset records, but shares the same workspace and editing password.

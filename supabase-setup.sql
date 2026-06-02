-- Run once in the Supabase SQL editor for your HollowNet project.
-- The browser calls only sync_hollownet_workspace(). Direct table access stays private.

create extension if not exists pgcrypto;

create table if not exists public.hollownet_workspaces (
  workspace_id text primary key
    check (workspace_id ~ '^[a-zA-Z0-9][a-zA-Z0-9_-]{2,63}$'),
  access_code_hash text not null,
  items jsonb not null default '[]'::jsonb
    check (jsonb_typeof(items) = 'array'),
  build_items jsonb not null default '[]'::jsonb
    check (jsonb_typeof(build_items) = 'array'),
  updated_at timestamptz not null default now()
);

alter table public.hollownet_workspaces
  add column if not exists build_items jsonb not null default '[]'::jsonb
    check (jsonb_typeof(build_items) = 'array');

alter table public.hollownet_workspaces enable row level security;
revoke all on table public.hollownet_workspaces from anon, authenticated;

create or replace function public.sync_hollownet_workspace(
  p_workspace_id text,
  p_access_code text,
  p_items jsonb default null
)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  existing_workspace public.hollownet_workspaces%rowtype;
begin
  if p_workspace_id is null
    or p_workspace_id !~ '^[a-zA-Z0-9][a-zA-Z0-9_-]{2,63}$' then
    raise exception 'Workspace ID must be 3-64 letters, numbers, dashes or underscores.';
  end if;

  if p_access_code is null or length(p_access_code) < 12 then
    raise exception 'Workspace access code must be at least 12 characters.';
  end if;

  if p_items is not null and jsonb_typeof(p_items) <> 'array' then
    raise exception 'Items must be a JSON array.';
  end if;

  select * into existing_workspace
  from public.hollownet_workspaces
  where workspace_id = p_workspace_id
  for update;

  if not found then
    insert into public.hollownet_workspaces(workspace_id, access_code_hash, items)
    values (
      p_workspace_id,
      crypt(p_access_code, gen_salt('bf')),
      coalesce(p_items, '[]'::jsonb)
    )
    returning * into existing_workspace;
  elsif existing_workspace.access_code_hash <> crypt(p_access_code, existing_workspace.access_code_hash) then
    raise exception 'Workspace access code is incorrect.';
  elsif p_items is not null then
    update public.hollownet_workspaces
    set items = p_items, updated_at = now()
    where workspace_id = p_workspace_id
    returning * into existing_workspace;
  end if;

  return existing_workspace.items;
end;
$$;

revoke all on function public.sync_hollownet_workspace(text, text, jsonb) from public;
grant execute on function public.sync_hollownet_workspace(text, text, jsonb) to anon, authenticated;

create or replace function public.load_hollownet_workspace(p_workspace_id text)
returns jsonb
language sql
security definer
set search_path = public
as $$
  select items from public.hollownet_workspaces where workspace_id = p_workspace_id;
$$;

revoke all on function public.load_hollownet_workspace(text) from public;
grant execute on function public.load_hollownet_workspace(text) to anon, authenticated;

create or replace function public.sync_hollownet_builds(
  p_workspace_id text,
  p_access_code text,
  p_builds jsonb default null
)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  existing_workspace public.hollownet_workspaces%rowtype;
begin
  if p_workspace_id is null
    or p_workspace_id !~ '^[a-zA-Z0-9][a-zA-Z0-9_-]{2,63}$' then
    raise exception 'Workspace ID must be 3-64 letters, numbers, dashes or underscores.';
  end if;

  if p_access_code is null or length(p_access_code) < 12 then
    raise exception 'Workspace access code must be at least 12 characters.';
  end if;

  if p_builds is not null and jsonb_typeof(p_builds) <> 'array' then
    raise exception 'Builds must be a JSON array.';
  end if;

  select * into existing_workspace
  from public.hollownet_workspaces
  where workspace_id = p_workspace_id
  for update;

  if not found then
    insert into public.hollownet_workspaces(workspace_id, access_code_hash, build_items)
    values (
      p_workspace_id,
      crypt(p_access_code, gen_salt('bf')),
      coalesce(p_builds, '[]'::jsonb)
    )
    returning * into existing_workspace;
  elsif existing_workspace.access_code_hash <> crypt(p_access_code, existing_workspace.access_code_hash) then
    raise exception 'Workspace access code is incorrect.';
  elsif p_builds is not null then
    update public.hollownet_workspaces
    set build_items = p_builds, updated_at = now()
    where workspace_id = p_workspace_id
    returning * into existing_workspace;
  end if;

  return existing_workspace.build_items;
end;
$$;

revoke all on function public.sync_hollownet_builds(text, text, jsonb) from public;
grant execute on function public.sync_hollownet_builds(text, text, jsonb) to anon, authenticated;

create or replace function public.load_hollownet_builds(p_workspace_id text)
returns jsonb
language sql
security definer
set search_path = public
as $$
  select build_items from public.hollownet_workspaces where workspace_id = p_workspace_id;
$$;

revoke all on function public.load_hollownet_builds(text) from public;
grant execute on function public.load_hollownet_builds(text) to anon, authenticated;

-- Public media bucket for asset-page photos and videos.
-- Uploads are insert-only, limited to this workspace folder, and capped at 50 MB.
insert into storage.buckets(id, name, public, file_size_limit, allowed_mime_types)
values (
  'hollownet-media',
  'hollownet-media',
  true,
  52428800,
  array['image/*', 'video/*']
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "HollowNet media browser uploads" on storage.objects;
create policy "HollowNet media browser uploads"
on storage.objects
for insert
to anon, authenticated
with check (
  bucket_id = 'hollownet-media'
  and (storage.foldername(name))[1] = 'house-in-the-hollow'
);

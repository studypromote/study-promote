-- STUDY PROMOTE: 初期データベース設定
-- Supabase Dashboard > SQL Editor で実行してください。
-- 既存の public.study_tasks とそのRLSポリシーは残します。

create table if not exists public.sp_subjects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  unique(user_id, name)
);

create table if not exists public.sp_materials (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_id uuid references public.sp_subjects(id) on delete set null,
  name text not null,
  progress integer not null default 0 check (progress between 0 and 100),
  created_at timestamptz not null default now()
);

create table if not exists public.sp_study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_id uuid references public.sp_subjects(id) on delete set null,
  duration_minutes integer not null check (duration_minutes between 1 and 1440),
  session_date date not null default current_date,
  started_at timestamptz not null default now()
);

alter table public.sp_subjects enable row level security;
alter table public.sp_materials enable row level security;
alter table public.sp_study_sessions enable row level security;

drop policy if exists "sp_subjects_select_own" on public.sp_subjects;
create policy "sp_subjects_select_own" on public.sp_subjects
for select to authenticated using (auth.uid() = user_id);
drop policy if exists "sp_subjects_insert_own" on public.sp_subjects;
create policy "sp_subjects_insert_own" on public.sp_subjects
for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "sp_subjects_update_own" on public.sp_subjects;
create policy "sp_subjects_update_own" on public.sp_subjects
for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "sp_subjects_delete_own" on public.sp_subjects;
create policy "sp_subjects_delete_own" on public.sp_subjects
for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "sp_materials_select_own" on public.sp_materials;
create policy "sp_materials_select_own" on public.sp_materials
for select to authenticated using (auth.uid() = user_id);
drop policy if exists "sp_materials_insert_own" on public.sp_materials;
create policy "sp_materials_insert_own" on public.sp_materials
for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "sp_materials_update_own" on public.sp_materials;
create policy "sp_materials_update_own" on public.sp_materials
for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "sp_materials_delete_own" on public.sp_materials;
create policy "sp_materials_delete_own" on public.sp_materials
for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "sp_sessions_select_own" on public.sp_study_sessions;
create policy "sp_sessions_select_own" on public.sp_study_sessions
for select to authenticated using (auth.uid() = user_id);
drop policy if exists "sp_sessions_insert_own" on public.sp_study_sessions;
create policy "sp_sessions_insert_own" on public.sp_study_sessions
for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "sp_sessions_update_own" on public.sp_study_sessions;
create policy "sp_sessions_update_own" on public.sp_study_sessions
for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "sp_sessions_delete_own" on public.sp_study_sessions;
create policy "sp_sessions_delete_own" on public.sp_study_sessions
for delete to authenticated using (auth.uid() = user_id);

grant select, insert, update, delete on public.sp_subjects to authenticated;
grant select, insert, update, delete on public.sp_materials to authenticated;
grant select, insert, update, delete on public.sp_study_sessions to authenticated;

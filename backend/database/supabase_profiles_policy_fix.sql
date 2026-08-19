-- supabase_profiles_policy_fix.sql
-- Safe script to remove problematic RLS policies on public.profiles and create secure, non-recursive policies.
-- Run this in Supabase SQL editor (make a backup first).

-- 1) Preview existing policies (run separately if you want):
-- SELECT polname, pg_get_expr(polqual, polrelid) AS using, pg_get_expr(polwithcheck, polrelid) AS with_check
-- FROM pg_policy
-- WHERE polrelid = 'public.profiles'::regclass;

-- 2) Drop all existing policies on public.profiles (non-destructive: uses IF EXISTS)
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT polname FROM pg_policy WHERE polrelid = 'public.profiles'::regclass LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.profiles;', r.polname);
  END LOOP;
END$$;

-- 3) Ensure row level security is enabled
ALTER TABLE IF EXISTS public.profiles ENABLE ROW LEVEL SECURITY;

-- IMPORTANT: choose the correct column that holds the auth user UUID for profiles.
-- Common options: 'id' (profile id equals auth uid) or 'user_id'.
-- If your table uses 'id' as the user UUID, keep 'id' in the predicates below.
-- If it uses 'user_id', replace 'id' with 'user_id'.

-- Using 'id' in these policies. Change below if your column name differs.

-- 4) Create safe policies that DO NOT do any SELECTs/subqueries on the same table
-- Allow anyone (authenticated) to SELECT their own profile
CREATE POLICY IF NOT EXISTS select_own_profile ON public.profiles
  FOR SELECT
  TO authenticated
  USING (id::text = auth.uid());

-- Allow authenticated users to INSERT only profiles that match their auth uid
CREATE POLICY IF NOT EXISTS insert_own_profile ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (id::text = auth.uid());

-- Allow authenticated users to UPDATE only their own profile
CREATE POLICY IF NOT EXISTS update_own_profile ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (id::text = auth.uid())
  WITH CHECK (id::text = auth.uid());

-- Allow authenticated users to DELETE only their own profile
CREATE POLICY IF NOT EXISTS delete_own_profile ON public.profiles
  FOR DELETE
  TO authenticated
  USING (id::text = auth.uid());

-- 5) If you have admin roles that should bypass RLS (e.g., role stored in 'role' column), add a separate policy:
-- Replace the condition below with your project's admin check if different.
CREATE POLICY IF NOT EXISTS admin_all_profiles ON public.profiles
  FOR ALL
  TO authenticated
  USING (role = 'admin')
  WITH CHECK (role = 'admin');

-- Notes:
-- - Do NOT call functions or SELECT from the same table inside USING/WITH CHECK; that causes recursion.
-- - If your auth uid is stored in another column (user_id), update the predicates accordingly.
-- - Test creating/updating profiles after running this script.

-- End of script

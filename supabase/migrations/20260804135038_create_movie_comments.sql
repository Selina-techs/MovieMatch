/*
# Create movie_comments table (single-tenant, no auth)

1. New Tables
- `movie_comments`
  - `id` (uuid, primary key)
  - `movie_id` (text, not null) — references the movie's local id from the static movie list
  - `author` (text, not null) — display name the commenter types in
  - `content` (text, not null) — the comment body
  - `created_at` (timestamptz, default now())

2. Security
- Enable RLS on `movie_comments`.
- Allow anon + authenticated CRUD because the app has no sign-in screen and comments are intentionally public/shared.

3. Indexes
- Index on `movie_id` for fast lookup of all comments for a given movie.
*/

CREATE TABLE IF NOT EXISTS movie_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  movie_id text NOT NULL,
  author text NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE movie_comments ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_movie_comments_movie_id ON movie_comments(movie_id);

DROP POLICY IF EXISTS "anon_select_movie_comments" ON movie_comments;
CREATE POLICY "anon_select_movie_comments"
ON movie_comments FOR SELECT
TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_movie_comments" ON movie_comments;
CREATE POLICY "anon_insert_movie_comments"
ON movie_comments FOR INSERT
TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_movie_comments" ON movie_comments;
CREATE POLICY "anon_update_movie_comments"
ON movie_comments FOR UPDATE
TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_movie_comments" ON movie_comments;
CREATE POLICY "anon_delete_movie_comments"
ON movie_comments FOR DELETE
TO anon, authenticated USING (true);

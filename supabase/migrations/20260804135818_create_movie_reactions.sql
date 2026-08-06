/*
# Create movie_reactions table (single-tenant, no auth)

1. New Tables
- `movie_reactions`
  - `id` (uuid, primary key)
  - `movie_id` (text, not null) — references the movie's local id from the static movie list
  - `reaction` (text, not null) — either 'like' or 'dislike'
  - `voter_id` (text, not null) — anonymous per-browser identifier stored in localStorage so one person can change their vote but not vote twice
  - `created_at` (timestamptz, default now())

2. Security
- Enable RLS on `movie_reactions`.
- Allow anon + authenticated CRUD because the app has no sign-in screen and reactions are intentionally public/shared.

3. Indexes
- Index on `movie_id` for fast counting of reactions per movie.
- Unique index on (movie_id, voter_id) so each browser can only have one reaction per movie.
*/

CREATE TABLE IF NOT EXISTS movie_reactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  movie_id text NOT NULL,
  reaction text NOT NULL CHECK (reaction IN ('like', 'dislike')),
  voter_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE movie_reactions ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_movie_reactions_movie_id ON movie_reactions(movie_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_movie_reactions_movie_voter ON movie_reactions(movie_id, voter_id);

DROP POLICY IF EXISTS "anon_select_movie_reactions" ON movie_reactions;
CREATE POLICY "anon_select_movie_reactions"
ON movie_reactions FOR SELECT
TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_movie_reactions" ON movie_reactions;
CREATE POLICY "anon_insert_movie_reactions"
ON movie_reactions FOR INSERT
TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_movie_reactions" ON movie_reactions;
CREATE POLICY "anon_update_movie_reactions"
ON movie_reactions FOR UPDATE
TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_movie_reactions" ON movie_reactions;
CREATE POLICY "anon_delete_movie_reactions"
ON movie_reactions FOR DELETE
TO anon, authenticated USING (true);

-- ============================================================
--  Quiz « Les Sentinelles de la Sécurité » — schéma Supabase
--  À coller dans : Supabase → SQL Editor → New query → Run
-- ============================================================

create table if not exists participations (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  nom         text not null,
  nom_normalise text not null,
  departement text not null,          -- FRAIS / CAISSE / PGC
  sous_rayon  text,                   -- rempli pour FRAIS (Boulangerie, Boucherie, ...)
  score       int  not null,
  total       int  not null default 13,
  phase       text not null default 'qualif'   -- 'qualif' ou 'finale'
);

-- Tentative unique : un même nom ne peut jouer qu'une fois par phase
create unique index if not exists participations_unique_joueur
  on participations (nom_normalise, phase);

-- Sécurité au niveau des lignes : lecture + insertion publiques,
-- mais PAS de modification ni de suppression via l'app (on nettoie depuis le dashboard).
alter table participations enable row level security;

drop policy if exists "lecture publique" on participations;
create policy "lecture publique" on participations
  for select using (true);

drop policy if exists "insertion publique" on participations;
create policy "insertion publique" on participations
  for insert with check (true);

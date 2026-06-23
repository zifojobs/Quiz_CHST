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
  duree_ms    int,                    -- temps total mis pour répondre (départage à score égal)
  phase       text not null default 'qualif'   -- 'qualif' ou 'finale'
);

-- Si la table existe déjà, ajouter la colonne de temps (à exécuter une fois) :
alter table participations add column if not exists duree_ms int;

-- Essais ILLIMITÉS : on autorise plusieurs participations par personne/phase
-- (le classement ne garde que le meilleur essai de chacun). On retire donc
-- l'ancien index unique s'il existe :
drop index if exists participations_unique_joueur;

-- Sécurité au niveau des lignes : lecture + insertion publiques,
-- mais PAS de modification ni de suppression via l'app (on nettoie depuis le dashboard).
alter table participations enable row level security;

drop policy if exists "lecture publique" on participations;
create policy "lecture publique" on participations
  for select using (true);

drop policy if exists "insertion publique" on participations;
create policy "insertion publique" on participations
  for insert with check (true);

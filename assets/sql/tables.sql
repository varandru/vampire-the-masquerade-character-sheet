-- General attribute description
create table if not exists attributes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT,
  type INTEGER -- 0 - physical, 1 - social, 2 - mental
);

create unique index if not exists idx_attribute_txt_id on attributes(txt_id);

create table if not exists attribute_specializations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  attribute_id INTEGER, 
  name TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

create table if not exists attribute_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  attribute_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

-- General ability description
create table if not exists abilities(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT,
  type INTEGER
);

create unique index if not exists idx_ability_txt_id on abilities(txt_id);

create table if not exists ability_specializations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ability_id INTEGER, 
  name TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

create table if not exists ability_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ability_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

-- General background description
create table if not exists backgrounds(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create unique index if not exists idx_background_txt_id on backgrounds(txt_id);

create table if not exists background_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  background_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(background_id) REFERENCES backgrounds(id)
);

-- Merits description
create table if not exists merits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INTEGER, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create unique index if not exists idx_merit_txt_id on merits(txt_id);

create table if not exists merit_costs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  merit_id INTEGER,
  cost INTEGER,
  FOREIGN KEY(merit_id) REFERENCES merits(id)
);

-- Flaws description
create table if not exists flaws (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INTEGER, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create unique index if not exists idx_flaw_txt_id on flaws(txt_id);

create table if not exists flaw_costs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flaw_id INTEGER,
  cost INTEGER,
  FOREIGN KEY(flaw_id) REFERENCES flaws(id)
);

-- Discipline description
create table if not exists disciplines (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT,
  maximum INTEGER, 
  system TEXT
);

create unique index if not exists idx_discipline_txt_id on disciplines(txt_id);

create table if not exists discipline_levels(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  discipline_id INTEGER, 
  level INTEGER,
  system TEXT, 
  maximum INTEGER, 
  description TEXT,
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

create table ritual_schools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT  
);

-- Rituals description
create table if not exists rituals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT, 
  discipline_id INTEGER, 
  level INTEGER, 
  description TEXT,
  system TEXT,
  FOREIGN KEY(discipline_id) REFERENCES ritual_schools(id)
);

create table if not exists characters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE,
  
  player_name TEXT,
  chronicle TEXT, 
  nature TEXT,
  demeanor TEXT,
  concept TEXT,
  clan TEXT,
  generation INTEGER, -- validation is done in the app
  sire TEXT, 

  conscience INTEGER,
  self_control INTEGER,
  courage INTEGER,

  humanity INTEGER,
  willpower INTEGER,
  blood_max INTEGER,

  will INTEGER,
  blood INTEGER
);

create unique index if not exists idx_character_name on characters(name);

-- Player's attributes. 
create table if not exists player_attributes(
  player_id INTEGER,
  attribute_id INTEGER,
  current INTEGER,
  specialization TEXT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(attribute_id) REFERENCES attributes(id),
  UNIQUE(player_id, attribute_id)
);

-- Player's abilities
create table if not exists player_abilities(
  player_id INTEGER,
  ability_id INTEGER,
  current INTEGER,
  specialization TEXT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ability_id) REFERENCES abilities(id),
  UNIQUE(player_id, ability_id)
);

-- Player's backgrounds
create table if not exists player_backgrounds(
  player_id INTEGER,
  background_id INTEGER,
  current INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(background_id) REFERENCES backgrounds(id),
  UNIQUE(player_id, background_id)
);

create table if not exists player_disciplines(
  player_id INTEGER,
  discipline_id INTEGER,
  level INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id),
  UNIQUE(player_id, discipline_id)
);

create table if not exists player_rituals(
  player_id INTEGER,
  ritual_id INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ritual_id) REFERENCES rituals(id),
  UNIQUE(player_id, ritual_id)
);

create table if not exists player_merits(
  player_id INTEGER,
  merit_id INTEGER,
  cost INTEGER, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(merit_id) REFERENCES merits(id),
  UNIQUE(player_id, merit_id)
);

create table if not exists player_flaws(
  player_id INTEGER,
  flaw_id INTEGER,
  cost INTEGER, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(flaw_id) REFERENCES flaws(id),
  UNIQUE(player_id, flaw_id)
);

create table if not exists player_xp(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_id INTEGER,

  cost INTEGER,
  description TEXT,
  name TEXT,
  old_level INTEGER,
  new_level INTEGER,

  FOREIGN KEY(player_id) REFERENCES characters(id)
);

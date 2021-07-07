-- General attribute description
create table attributes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT,
  type INTEGER -- 0 - physical, 1 - social, 2 - mental
);

create unique index idx_attribute_txt_id on attributes(txt_id);

create table attribute_specializations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  attribute_id INTEGER, 
  name TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

create table attribute_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  attribute_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

-- General ability description
create table abilities(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create unique index idx_ability_txt_id on abilities(txt_id);

create table ability_specializations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ability_id INTEGER, 
  name TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

create table ability_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ability_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

-- General background description
create table backgrounds(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create unique index idx_background_txt_id on backgrounds(txt_id);

create table background_levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  background_id INTEGER, 
  level INTEGER,
  description TEXT,
  FOREIGN KEY(background_id) REFERENCES backgrounds(id)
);

-- Merits description
create table merits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INTEGER, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create unique index idx_merit_txt_id on merits(txt_id);

create table merit_costs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  merit_id INTEGER,
  cost INTEGER,
  FOREIGN KEY(merit_id) REFERENCES merits(id)
);

-- Flaws description
create table flaws (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INTEGER, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create unique index idx_flaw_txt_id on flaws(txt_id);

create table flaw_costs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flaw_id INTEGER,
  cost INTEGER,
  FOREIGN KEY(flaw_id) REFERENCES flaws(id)
);

-- Discipline description
create table disciplines (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT,
  maximum INTEGER, 
  system TEXT
);

create unique index idx_discipline_txt_id on disciplines(txt_id);

create table discipline_levels(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  discipline_id INTEGER, 
  level INTEGER,
  system TEXT, 
  maximum INTEGER, 
  description TEXT,
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

-- Rituals description
create table rituals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT, 
  discipline_id INTEGER, 
  level INTEGER, 
  description TEXT,
  system TEXT,
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

create table characters (
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

  additional_humanity INTEGER,
  additional_willpower INTEGER,
  blood_max INTEGER,

  will INTEGER,
  blood INTEGER
);

create unique index idx_character_name on characters(name);

-- Player's attributes. 
create table player_attributes(
  player_id INTEGER,
  attribute_id INTEGER,
  current INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

-- Player's abilities
create table player_abilities(
  player_id INTEGER,
  ability_id INTEGER,
  current INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

-- Player's backgrounds
create table player_backgrounds(
  player_id INTEGER,
  background_id INTEGER,
  current INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(background_id) REFERENCES backgrounds(id)
);

create table player_disciplines(
  player_id INTEGER,
  discipline_id INTEGER,
  level INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

create table player_rituals(
  player_id INTEGER,
  ritual_id INTEGER,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ritual_id) REFERENCES rituals(id)
);

create table player_merits(
  player_id INTEGER,
  merit_id INTEGER,
  cost INTEGER, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(merit_id) REFERENCES merits(id)
);

create table player_flaws(
  player_id INTEGER,
  flaw_id INTEGER,
  cost INTEGER, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(flaw_id) REFERENCES flaws(id)
);

create table player_xp(
  player_id INTEGER,

  cost INTEGER,
  description TEXT,
  name TEXT,
  old_level INTEGER,
  new_level INTEGER,

  FOREIGN KEY(player_id) REFERENCES characters(id)
);

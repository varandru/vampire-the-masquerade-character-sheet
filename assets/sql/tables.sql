-- General attribute description
create table attributes(
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create table attribute_specializations (
  id INT PRIMARY KEY AUTOINCREMENT,
  attribute_id INT, 
  name TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

create table attribute_levels (
  id INT PRIMARY KEY AUTOINCREMENT,
  attribute_id INT, 
  level INT,
  description TEXT,
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

-- General ability description
create table abilities(
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create table ability_specializations (
  id INT PRIMARY KEY AUTOINCREMENT,
  ability_id INT, 
  name TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

create table ability_levels (
  id INT PRIMARY KEY AUTOINCREMENT,
  ability_id INT, 
  level INT,
  description TEXT,
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

-- General background description
create table backgrounds(
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  description TEXT
);

create table background_specializations (
  id INT PRIMARY KEY AUTOINCREMENT,
  background_id INT, 
  name TEXT,
  FOREIGN KEY(background_id) REFERENCES backgrounds(id)
);

create table background_levels (
  id INT PRIMARY KEY AUTOINCREMENT,
  background_id INT, 
  level INT,
  description TEXT,
  FOREIGN KEY(background_id) REFERENCES backgrounds(id)
);

-- Merits description
create table merits (
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INT, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create table merit_levels (
  id INT PRIMARY KEY AUTOINCREMENT,
  merit_id INT,
  level INT,
  FOREIGN KEY(merit_id) REFERENCES merits(id)
);

-- Flaws description
create table flaws (
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT,
  type INT, -- 1 - physical, 2 - mental, 3 - social, 4 - supernatural, 0 - undefined
  description TEXT
);

create table flaw_levels (
  id INT PRIMARY KEY AUTOINCREMENT,
  flaw_id INT,
  level INT,
  FOREIGN KEY(flaw_id) REFERENCES flaws(id)
);

-- Discipline description
create table disciplines (
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  description TEXT,
  maximum int, 
  system TEXT
);

create table discipline_levels(
  id INT PRIMARY KEY AUTOINCREMENT,
  discipline_id INT, 
  level INT,
  system TEXT, 
  maximum INT, 
  description TEXT,
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

-- Rituals description
create table rituals (
  id INT PRIMARY KEY AUTOINCREMENT,
  txt_id TEXT UNIQUE,
  name TEXT, 
  discipline_id INT, 
  level INT, 
  description TEXT,
  system TEXT,
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

create table characters (
  id INT PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE INDEX,
  
  player_name TEXT,
  chronicle TEXT, 
  nature TEXT,
  demeanor TEXT,
  concept TEXT,
  clan TEXT,
  generation INT, -- validation is done in the app
  sire TEXT, 

  conscience INT,
  self_control INT,
  courage INT,

  additional_humanity INT,
  additional_willpower INT,
  blood_max INT,

  will INT,
  blood INT
);

-- Player's attributes. 
create table player_attributes(
  player_id INT,
  attribute_id INT,
  current INT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(attribute_id) REFERENCES attributes(id)
);

-- Player's abilities
create table player_abilities(
  player_id INT,
  ability_id INT,
  current INT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ability_id) REFERENCES abilities(id)
);

create table player_disciplines(
  player_id INT,
  discipline_id INT,
  level INT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(discipline_id) REFERENCES disciplines(id)
);

create table player_rituals(
  player_id INT,
  ritual_id INT,
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(ritual_id) REFERENCES rituals(id)
);

create table player_merits(
  player_id INT,
  merit_id INT,
  cost INT, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(merit_id) REFERENCES merits(id)
);

create table player_flaws(
  player_id INT,
  flaw_id INT,
  cost INT, 
  FOREIGN KEY(player_id) REFERENCES characters(id),
  FOREIGN KEY(flaw_id) REFERENCES flaws(id)
);

create table player_xp(
  player_id INT,

  cost INT,
  description TEXT,
  name TEXT,
  old_level INT,
  new_level INT,

  FOREIGN KEY(player_id) REFERENCES characters(id)
);

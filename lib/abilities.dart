import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'common_logic.dart';
import 'database.dart';

enum AbilityColumnType { Talents, Skills, Knowledges }

class SkillDatabase extends ComplexAbilityEntryDatabaseDescription {
  SkillDatabase(int filter)
      : super(
          tableName: 'abilities',
          fkName: 'ability_id',
          playerLinkTable: 'player_abilities',
          specializationsTable: 'ability_specializations',
          filter: filter,
        );
}

class TalentsDatabase extends SkillDatabase {
  TalentsDatabase() : super(0);
}

class SkillsDatabase extends SkillDatabase {
  SkillsDatabase() : super(1);
}

class KnowledgeDatabase extends SkillDatabase {
  KnowledgeDatabase() : super(2);
}

class AbilitiesController extends GetxController {
  var talents = ComplexAbilityColumn('Talents', description: TalentsDatabase());
  var skills = ComplexAbilityColumn('Skills', description: SkillsDatabase());
  var knowledges =
      ComplexAbilityColumn('Knowledges', description: KnowledgeDatabase());

  ComplexAbilityColumn getColumnByType(AbilityColumnType type) {
    switch (type) {
      case AbilityColumnType.Talents:
        return talents;
      case AbilityColumnType.Skills:
        return skills;
      case AbilityColumnType.Knowledges:
        return knowledges;
    }
  }

  void fromJson(Map<String, dynamic> json) {
    _fillAbilityListByType(AbilityColumnType.Talents, json["talents"]);
    _fillAbilityListByType(AbilityColumnType.Skills, json["skills"]);
    _fillAbilityListByType(AbilityColumnType.Knowledges, json["knowledges"]);
  }

  // Fills abilities from JSON
  void _fillAbilityListByType(
      AbilityColumnType type, Map<String, dynamic> abilities) async {
    for (var id in abilities.keys) {
      if (abilities[id] != null && abilities[id] is Map<String, dynamic>) {
        var response = await Get.find<DatabaseController>().database.query(
            'abilities',
            columns: ['id', 'name'],
            where: 'txt_id = ?',
            whereArgs: [id]);

        String name = 'Not found';
        if (response.length > 0) if (response[0]['name'] != null)
          name = response[0]['name'] as String;
        ComplexAbility ca = ComplexAbility(
          id: response[0]['id'] as int,
          txtId: id,
          name: name,
          current: abilities[id]["current"] ?? 0,
          min: 0,
          max: 5,
          specialization: abilities[id]["specialization"] ?? "",
          isIncremental: true, // Abilities are incremental, AFAIK
        );

        switch (type) {
          case AbilityColumnType.Talents:
            talents.add(ca);
            break;
          case AbilityColumnType.Skills:
            skills.add(ca);
            break;
          case AbilityColumnType.Knowledges:
            knowledges.add(ca);
            break;
        }
      }
    }
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["talents"] = getColumnByType(AbilityColumnType.Talents);
    json["skills"] = getColumnByType(AbilityColumnType.Skills);
    json["knowledges"] = getColumnByType(AbilityColumnType.Knowledges);
    return json;
  }

  void fromDatabase(Database database) async {
    talents.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from abilities a inner join player_abilities pa '
        'on pa.ability_id = a.id where pa.player_id = ? and a.type = 0',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => ComplexAbility(
              id: value[0]['id'] as int,
              name: value[0]['name'] as String,
              current: value[0]['current'] as int,
              specialization: value[0]['specialization'] as String? ?? "",
              hasSpecialization: true,
            )));
    skills.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from abilities a inner join player_abilities pa '
        'on pa.ability_id = a.id where pa.player_id = ? and a.type = 1',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => ComplexAbility(
              id: value[0]['id'] as int,
              name: value[0]['name'] as String,
              current: value[0]['current'] as int,
              specialization: value[0]['specialization'] as String? ?? "",
              hasSpecialization: true,
            )));
    knowledges.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from abilities a inner join player_abilities pa '
        'on pa.ability_id = a.id where pa.player_id = ? and a.type = 2',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => ComplexAbility(
              id: value[0]['id'] as int,
              name: value[0]['name'] as String,
              current: value[0]['current'] as int,
              specialization: value[0]['specialization'] as String? ?? "",
              hasSpecialization: true,
            )));
  }
}

class AbilitiesDictionary extends Dictionary {
  AbilitiesDictionary(String file) : super(file);

  Map<String, ComplexAbilityEntry> talents = Map();
  Map<String, ComplexAbilityEntry> skills = Map();
  Map<String, ComplexAbilityEntry> knowledges = Map();

  String talentAbilitiesName = "Talents";
  String skillsAbilitiesName = "Skills";
  String knowledgeAbilitiesName = "Knowledges";

  // abilities will work in the same way, with the same schema
  Map<int, String> levelPrefixes = Map();

  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all

    // 2. Get level prefixes
    if (json["level_prefixes"] != null && json["level_prefixes"] is List) {
      for (var prefix in json["level_prefixes"]) {
        levelPrefixes[prefix["level"]] = prefix["prefix"];
      }
    }
    // 3. Get ability categories
    if (json["ability_names"] != null) {
      talentAbilitiesName = json["ability_names"]["talents"];
      skillsAbilitiesName = json["ability_names"]["skills"];
      knowledgeAbilitiesName = json["ability_names"]["knowledges"];
    }

    // 4. Get talents
    if (json["talents"] != null && json["talents"] is Map<String, dynamic>) {
      for (var id in json["talents"].keys) {
        if (json["talents"][id] == null) continue;
        talents[id] = ComplexAbilityEntry.fromJson(json["talents"][id]);
      }
    }
    // 5. Get skills
    if (json["skills"] != null && json["skills"] is Map<String, dynamic>) {
      for (var id in json["skills"].keys) {
        if (json["skills"][id] == null) continue;
        skills[id] = ComplexAbilityEntry.fromJson(json["skills"][id]);
      }
    }
    // 6. Get knowledges
    if (json["knowledges"] != null &&
        json["knowledges"] is Map<String, dynamic>) {
      for (var id in json["knowledges"].keys) {
        if (json["knowledges"][id] == null) continue;
        knowledges[id] = ComplexAbilityEntry.fromJson(json["knowledges"][id]);
      }
    }
  }

  @override
  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();

    // CRUTCH until localization
    json["locale"] = "en-US";

    json["ability_names"] = <String, dynamic>{
      "talents": talentAbilitiesName,
      "skills": skillsAbilitiesName,
      "knowledges": knowledgeAbilitiesName
    };

    json["level_prefixes"] = levelPrefixes;

    json["talents"] = talents;
    json["skills"] = skills;
    json["knowledges"] = knowledges;

    return json;
  }

  @override
  Future<void> loadAllToDatabase(Database database) async {
    for (var textId in talents.keys) {
      int id = await database.insert(
          'abilities', talents[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (talents[textId]!.specializations.isNotEmpty) {
        for (var entry
            in talents[textId]!.specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (talents[textId]!.levels.isNotEmpty) {
        for (var entry
            in talents[textId]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in skills.keys) {
      int id = await database.insert(
          'abilities', skills[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (skills[textId]!.specializations.isNotEmpty) {
        for (var entry
            in skills[textId]!.specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (skills[textId]!.levels.isNotEmpty) {
        for (var entry in skills[textId]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in knowledges.keys) {
      int id = await database.insert(
          'abilities', knowledges[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (knowledges[textId]!.specializations.isNotEmpty) {
        for (var entry in knowledges[textId]!
            .specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (knowledges[textId]!.levels.isNotEmpty) {
        for (var entry
            in knowledges[textId]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }
}

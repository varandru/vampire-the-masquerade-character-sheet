import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'common_logic.dart';

enum AbilityColumnType { Talents, Skills, Knowledges }

class AbilitiesController extends GetxController {
  var talents = ComplexAbilityColumn('Talents');
  var skills = ComplexAbilityColumn('Skills');
  var knowledges = ComplexAbilityColumn('Knowledges');

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

  void load(Map<String, dynamic> json, AbilitiesDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.talentAbilitiesName.isNotEmpty) {
      talents.name.value = dictionary.talentAbilitiesName;
    }
    if (dictionary.skillsAbilitiesName.isNotEmpty) {
      skills.name.value = dictionary.skillsAbilitiesName;
    }
    if (dictionary.knowledgeAbilitiesName.isNotEmpty) {
      knowledges.name.value = dictionary.knowledgeAbilitiesName;
    }

    _fillAbilityListByType(
        AbilityColumnType.Talents, json["talents"], dictionary);
    _fillAbilityListByType(
        AbilityColumnType.Skills, json["skills"], dictionary);
    _fillAbilityListByType(
        AbilityColumnType.Knowledges, json["knowledges"], dictionary);
  }

  void _fillAbilityListByType(AbilityColumnType type,
      Map<String, dynamic> abilities, AbilitiesDictionary dictionary) {
    for (var id in abilities.keys) {
      if (abilities[id] != null && abilities[id] is Map<String, dynamic>) {
        ComplexAbilityEntry? entry;

        switch (type) {
          case AbilityColumnType.Talents:
            entry = dictionary.talents[id];
            break;
          case AbilityColumnType.Skills:
            entry = dictionary.skills[id];
            break;
          case AbilityColumnType.Knowledges:
            entry = dictionary.knowledges[id];
            break;
        }

        if (entry == null) {
          // If a stat is not found, add an empty one
          entry = ComplexAbilityEntry(name: id);
          switch (type) {
            case AbilityColumnType.Talents:
              dictionary.talents[id] = entry;
              break;
            case AbilityColumnType.Skills:
              dictionary.skills[id] = entry;
              break;
            case AbilityColumnType.Knowledges:
              dictionary.knowledges[id] = entry;
              break;
          }

          dictionary.changed = true;
        }

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
          id: id,
          name: entry.name,
          current: abilities[id]["current"] ?? 0,
          min: 0,
          max: 5,
          specialization: abilities[id]["specialization"] ?? "",
          isIncremental: true, // Abilities are incremental, AFAIK
        );

        print("Ability: ${ca.name}, $id");

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
}

class AbilitiesDictionary extends Dictionary {
  AbilitiesDictionary(String file) : super(file);

  Map<String, ComplexAbilityEntry> talents = Map();
  Map<String, ComplexAbilityEntry> skills = Map();
  Map<String, ComplexAbilityEntry> knowledges = Map();

  String talentAbilitiesName = "Talents";
  String skillsAbilitiesName = "Skills";
  String knowledgeAbilitiesName = "Knowledges";

  // Attributes will work in the same way, with the same schema
  Map<int, String> levelPrefixes = Map();

  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all

    // 2. Get level prefixes
    if (json["level_prefixes"] != null && json["level_prefixes"] is List) {
      for (var prefix in json["level_prefixes"]) {
        levelPrefixes[prefix["level"]] = prefix["prefix"];
      }
    }
    // 3. Get attribute categories
    if (json["attribute_names"] != null) {
      talentAbilitiesName = json["attribute_names"]["talents"];
      skillsAbilitiesName = json["attribute_names"]["skills"];
      knowledgeAbilitiesName = json["attribute_names"]["knowledges"];
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

    json["attribute_names"] = <String, dynamic>{
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
  void loadAllToDatabase(Database database) async {
    for (var textId in talents.keys) {
      int id = await database.insert(
          'abilities', talents[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (talents[id]!.specializations.isNotEmpty) {
        for (var entry
            in talents[id]!.specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (talents[id]!.levels.isNotEmpty) {
        for (var entry in talents[id]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in skills.keys) {
      int id = await database.insert(
          'abilities', skills[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (skills[id]!.specializations.isNotEmpty) {
        for (var entry
            in skills[id]!.specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (skills[id]!.levels.isNotEmpty) {
        for (var entry in skills[id]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in knowledges.keys) {
      int id = await database.insert(
          'abilities', knowledges[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (knowledges[id]!.specializations.isNotEmpty) {
        for (var entry
            in knowledges[id]!.specializationsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (knowledges[id]!.levels.isNotEmpty) {
        for (var entry in knowledges[id]!.levelsToDatabase(id, 'ability_id')!) {
          await database.insert('ability_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }
}

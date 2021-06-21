import 'package:get/get.dart';

import 'common_logic.dart';

enum AbilityColumnType { Talents, Skills, Knowledges }

class AbilitiesController extends GetxController {
  ComplexAbilityColumn talents = ComplexAbilityColumn('Talents');
  ComplexAbilityColumn skills = ComplexAbilityColumn('Skills');
  ComplexAbilityColumn knowledges = ComplexAbilityColumn('Knowledges');

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

  //CRUTCH: This is a crutch for Web debug
  void initializeFromConstants() {
    talents.values.value = TalentsAbilitiesColumn().attributes;
    skills.values.value = SkillsAbilitiesColumn().attributes;
    knowledges.values.value = KnowledgeAbilitiesColumn().attributes;
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

    _fillAttributeListByType(
        AbilityColumnType.Talents, json["talents"], dictionary);
    _fillAttributeListByType(
        AbilityColumnType.Skills, json["skills"], dictionary);
    _fillAttributeListByType(
        AbilityColumnType.Knowledges, json["knowledges"], dictionary);
  }

  void _fillAttributeListByType(AbilityColumnType type,
      List<dynamic> attributes, AbilitiesDictionary dictionary) {
    for (var attribute in attributes) {
      if (attribute["name"] != null && attribute is Map<String, dynamic>) {
        String name = attribute["name"];

        ComplexAbilityEntry? entry;

        switch (type) {
          case AbilityColumnType.Talents:
            entry = dictionary.talents[name];
            break;
          case AbilityColumnType.Skills:
            entry = dictionary.skills[name];
            break;
          case AbilityColumnType.Knowledges:
            entry = dictionary.knowledges[name];
            break;
        }

        if (entry == null) {
          // If a stat is not found, add an empty one
          entry = ComplexAbilityEntry();
          switch (type) {
            case AbilityColumnType.Talents:
              dictionary.talents[name] = entry;
              break;
            case AbilityColumnType.Skills:
              dictionary.skills[name] = entry;
              break;
            case AbilityColumnType.Knowledges:
              dictionary.knowledges[name] = entry;
              break;
          }
        }

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
          name: name,
          current: attribute["current"] ?? 0,
          min: 0,
          max: 5,
          specialization: attribute["specialization"] ?? "",
          description: entry.description ?? "",
          isIncremental: true, // Attributes are incremental, AFAIK
        );

        print(
            "Adding ability $type: '${ca.name}', ${ca.current}, '${ca.specialization}', '${ca.description}'");

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

class TalentsAbilitiesColumn {
  final header = "Talents";

  var attributes = [
    ComplexAbility(name: "Alertness", current: 2),
    ComplexAbility(name: "Athletics", current: 0),
    ComplexAbility(name: "Brawl", current: 0),
    ComplexAbility(name: "Dodge", current: 3),
    ComplexAbility(name: "Empathy", current: 0),
    ComplexAbility(name: "Expression", current: 0),
    ComplexAbility(name: "Intimidation", current: 0),
    ComplexAbility(name: "Leadership", current: 0),
    ComplexAbility(name: "Streetwise", current: 0),
    ComplexAbility(name: "Subterfuge", current: 0),
  ];
}

class SkillsAbilitiesColumn {
  final header = "Skills";

  var attributes = [
    ComplexAbility(name: "Animal", current: 0),
    ComplexAbility(name: "Crafts", current: 0),
    ComplexAbility(name: "Drive", current: 0),
    ComplexAbility(name: "Etiquette", current: 0),
    ComplexAbility(name: "Firearms", current: 3),
    ComplexAbility(name: "Melee", current: 0),
    ComplexAbility(name: "Performance", current: 0),
    ComplexAbility(name: "Security", current: 3),
    ComplexAbility(name: "Stealth", current: 3),
    ComplexAbility(name: "Survival", current: 0),
  ];
}

class KnowledgeAbilitiesColumn {
  final header = "Knowledges";

  var attributes = [
    ComplexAbility(name: "Academics", current: 0),
    ComplexAbility(
        name: "Computers", current: 4, specialization: "Passwords Hacking"),
    ComplexAbility(name: "Finance", current: 0),
    ComplexAbility(name: "Investigation", current: 3),
    ComplexAbility(name: "Law", current: 0),
    ComplexAbility(name: "Linguistics", current: 2),
    ComplexAbility(name: "Medicine", current: 2),
    ComplexAbility(name: "Occult", current: 3),
    ComplexAbility(name: "Politics", current: 0),
    ComplexAbility(name: "Science", current: 0),
  ];
}

// TODO: at some point dictionary should be refactored
class AbilitiesDictionary {
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

    // 4. Get physical attributes
    if (json["talents"] != null && json["talents"] is List) {
      for (var attribute in json["talents"]) {
        if (attribute["name"] == null) continue;
        talents[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
    // 5. Get social attributes
    if (json["skills"] != null && json["skills"] is List) {
      for (var attribute in json["skills"]) {
        if (attribute["name"] == null) continue;
        skills[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
    // 6. Get mental attributes
    if (json["knowledges"] != null && json["knowledges"] is List) {
      for (var attribute in json["knowledges"]) {
        if (attribute["name"] == null) continue;
        knowledges[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
  }

  ComplexAbilityEntry _getAttributeFromJson(Map<String, dynamic> attribute) {
    ComplexAbilityEntry entry = ComplexAbilityEntry();
    if (attribute["specialization"] != null) {
      if (attribute["specialization"] is List) {
        for (var specialization in attribute["specialization"]) {
          entry.specializations.add(specialization);
        }
      } else {
        print("${attribute["name"]}'s specializations are not a list");
      }
    } else {
      print("${attribute["name"]} does not have specializations");
    }
    if (attribute["levels"] != null) {
      if (attribute["levels"] is List) {
        for (var level in attribute["levels"]) {
          entry.levels.add(level);
        }
      } else {
        print("${attribute["name"]}'s levels are not a list");
      }
    } else {
      print("${attribute["name"]} does not have levels");
    }
    entry.description = attribute["description"];

    return entry;
  }
}

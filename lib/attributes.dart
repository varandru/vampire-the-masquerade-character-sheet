import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'common_logic.dart';
import 'database.dart';

enum AttributeColumnType { Physical, Mental, Social }

class Attribute extends ComplexAbility {
  Attribute({
    required int? id,
    required String name,
    String? txtId,
    int current = 1,
    int min = 0,
    int max = 5,
    String specialization = "",
  }) : super(
            id: id,
            name: name,
            txtId: txtId,
            current: current,
            min: min,
            max: max,
            specialization: specialization,
            isIncremental: true,
            hasSpecialization: true,
            isDeletable: false);
}

class AttributeDatabase extends ComplexAbilityEntryDatabaseDescription {
  AttributeDatabase(int filter)
      : super(
          tableName: 'attributes',
          fkName: 'attribute_id',
          playerLinkTable: 'player_attributes',
          specializationsTable: 'attribute_specializations',
          filter: filter,
        );
}

class PhysicalDatabase extends AttributeDatabase {
  PhysicalDatabase() : super(0);
}

class SocialDatabase extends AttributeDatabase {
  SocialDatabase() : super(1);
}

class MentalDatabase extends AttributeDatabase {
  MentalDatabase() : super(2);
}

class AttributesController extends GetxController {
  ComplexAbilityColumn physicalAttributes =
      ComplexAbilityColumn('Physical', description: PhysicalDatabase());
  ComplexAbilityColumn socialAttributes =
      ComplexAbilityColumn('Mental', description: MentalDatabase());
  ComplexAbilityColumn mentalAttributes =
      ComplexAbilityColumn('Social', description: SocialDatabase());

  ComplexAbilityColumn getColumnByType(AttributeColumnType type) {
    switch (type) {
      case AttributeColumnType.Physical:
        return physicalAttributes;
      case AttributeColumnType.Mental:
        return mentalAttributes;
      case AttributeColumnType.Social:
        return socialAttributes;
    }
  }

  List<ComplexAbility> get attributes =>
      physicalAttributes.values +
      mentalAttributes.values +
      socialAttributes.values;

  void load(Map<String, dynamic> json, AttributeDictionary dictionary) {
    _fillAttributeListByType(
        AttributeColumnType.Physical, json["physical"], dictionary.physical);
    _fillAttributeListByType(
        AttributeColumnType.Mental, json["mental"], dictionary.mental);
    _fillAttributeListByType(
        AttributeColumnType.Social, json["social"], dictionary.social);
  }

  void _fillAttributeListByType(
      AttributeColumnType type,
      Map<String, dynamic> attributes,
      Map<String, ComplexAbilityEntry> dictionary) {
    for (var id in attributes.keys) {
      if (attributes[id] != null && attributes[id] is Map<String, dynamic>) {
        ComplexAbilityEntry? entry = dictionary[id];

        // CRUTCH This doesn't allow attributes to go above 5
        Attribute ca = Attribute(
            txtId: id,
            id: null,
            name: entry?.name ?? "WIP Attribute",
            current: attributes[id]["current"] ?? 1,
            specialization: attributes[id]["specialization"] ?? "",
            min: 0,
            max: 5);

        switch (type) {
          case AttributeColumnType.Physical:
            physicalAttributes.add(ca);
            break;
          case AttributeColumnType.Mental:
            mentalAttributes.add(ca);

            break;
          case AttributeColumnType.Social:
            socialAttributes.add(ca);

            break;
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["physical"] = _getAttributeListByType(AttributeColumnType.Physical);
    json["mental"] = _getAttributeListByType(AttributeColumnType.Mental);
    json["social"] = _getAttributeListByType(AttributeColumnType.Social);
    return json;
  }

  List<Map<String, dynamic>> _getAttributeListByType(AttributeColumnType type) {
    var column = getColumnByType(type);
    List<Map<String, dynamic>> shortAttributes = [];
    for (var attribute in column.values) {
      Map<String, dynamic> attr = Map();
      attr["name"] = attribute.name;
      attr["current"] = attribute.current;
      attr["specialization"] = attribute.specialization;
      shortAttributes.add(attr);
    }
    return shortAttributes;
  }

  void fromDatabase(Database database) async {
    physicalAttributes.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from attributes a inner join player_attributes pa '
        'on pa.attribute_id = a.id where pa.player_id = ? and a.type = 0',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Attribute(
              id: value[index]['id'] as int,
              name: value[index]['name'] as String,
              current: value[index]['current'] as int,
              specialization: value[index]['specialization'] as String? ?? "",
            )));

    socialAttributes.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from attributes a inner join player_attributes pa '
        'on pa.attribute_id = a.id where pa.player_id = ? and a.type = 1',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Attribute(
              id: value[index]['id'] as int,
              name: value[index]['name'] as String,
              current: value[index]['current'] as int,
              specialization: value[index]['specialization'] as String? ?? "",
            )));

    mentalAttributes.values.value = await database.rawQuery(
        'select a.id, a.name, pa.current, pa.specialization '
        'from attributes a inner join player_attributes pa '
        'on pa.attribute_id = a.id where pa.player_id = ? and a.type = 2',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Attribute(
              id: value[index]['id'] as int,
              name: value[index]['name'] as String,
              current: value[index]['current'] as int,
              specialization: value[index]['specialization'] as String? ?? "",
            )));
  }
}

class AttributeDictionary extends Dictionary {
  AttributeDictionary(String file) : super(file);

  Map<String, ComplexAbilityEntry> physical = Map();
  Map<String, ComplexAbilityEntry> social = Map();
  Map<String, ComplexAbilityEntry> mental = Map();

  String physicalAttributesName = "Physical";
  String socialAttributesName = "Social";
  String mentalAttributesName = "Mental";

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
      physicalAttributesName = json["attribute_names"]["physical"];
      socialAttributesName = json["attribute_names"]["social"];
      mentalAttributesName = json["attribute_names"]["mental"];
    }

    // 4. Get physical attributes
    if (json["physical"] != null && json["physical"] is Map<String, dynamic>) {
      for (var id in json["physical"].keys) {
        if (json["physical"][id] == null) continue;
        physical[id] = ComplexAbilityEntry.fromJson(json["physical"][id]);
      }
    }
    // 5. Get social attributes
    if (json["social"] != null && json["social"] is Map<String, dynamic>) {
      for (var id in json["social"].keys) {
        if (json["social"][id] == null) continue;
        social[id] = ComplexAbilityEntry.fromJson(json["social"][id]);
      }
    }
    // 6. Get mental attributes
    if (json["mental"] != null && json["mental"] is Map<String, dynamic>) {
      for (var id in json["mental"].keys) {
        if (json["mental"][id] == null) continue;
        mental[id] = ComplexAbilityEntry.fromJson(json["mental"][id]);
      }
    }
  }

  @override
  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();

    // CRUTCH until localization
    json["locale"] = "en-US";

    json["attribute_names"] = <String, dynamic>{
      "physical": physicalAttributesName,
      "social": socialAttributesName,
      "mental": mentalAttributesName
    };

    json["level_prefixes"] = levelPrefixes;

    json["physical"] = physical;
    json["social"] = social;
    json["mental"] = mental;

    return json;
  }

  @override
  Future<void> loadAllToDatabase(Database database) async {
    for (var textId in physical.keys) {
      int id = await database.insert(
          'attributes', physical[textId]!.toDatabaseMap(textId, 0),
          conflictAlgorithm: ConflictAlgorithm.rollback);
      if (physical[textId]!.specializations.isNotEmpty) {
        for (var entry in physical[textId]!
            .specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
      if (physical[textId]!.levels.isNotEmpty) {
        for (var entry
            in physical[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
    }
    for (var textId in social.keys) {
      int id = await database.insert(
          'attributes', social[textId]!.toDatabaseMap(textId, 1),
          conflictAlgorithm: ConflictAlgorithm.rollback);
      if (social[textId]!.specializations.isNotEmpty) {
        for (var entry
            in social[textId]!.specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
      if (social[textId]!.levels.isNotEmpty) {
        for (var entry
            in social[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
    }
    for (var textId in mental.keys) {
      int id = await database.insert(
          'attributes', mental[textId]!.toDatabaseMap(textId, 2),
          conflictAlgorithm: ConflictAlgorithm.rollback);
      if (mental[textId]!.specializations.isNotEmpty) {
        for (var entry
            in mental[textId]!.specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
      if (mental[textId]!.levels.isNotEmpty) {
        for (var entry
            in mental[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.rollback);
        }
      }
    }
  }
}

import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'common_logic.dart';

enum AttributeColumnType { Physical, Mental, Social }

class AttributesController extends GetxController {
  ComplexAbilityColumn physicalAttributes = ComplexAbilityColumn('Physical');
  ComplexAbilityColumn socialAttributes = ComplexAbilityColumn('Mental');
  ComplexAbilityColumn mentalAttributes = ComplexAbilityColumn('Social');

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

  void load(Map<String, dynamic> json) {
    _fillAttributeListByType(AttributeColumnType.Physical, json["physical"]);
    _fillAttributeListByType(AttributeColumnType.Mental, json["mental"]);
    _fillAttributeListByType(AttributeColumnType.Social, json["social"]);
  }

  void _fillAttributeListByType(
      AttributeColumnType type, Map<String, dynamic> attributes) {
    for (var id in attributes.keys) {
      if (attributes[id] != null && attributes[id] is Map<String, dynamic>) {
        // ComplexAbilityEntry? entry;
        // TODO: load entry here, it needs a name

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
            txtId: id,
            id: null,
            name: "WIP Attribute",
            current: attributes[id]["current"] ?? 1,
            specialization: attributes[id]["specialization"] ?? "",
            min: 0,
            max: 5,
            isIncremental: true, // Attributes are incremental, AFAIK
            isDeletable: false);

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
          'attributes', physical[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (physical[textId]!.specializations.isNotEmpty) {
        for (var entry in physical[textId]!
            .specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (physical[textId]!.levels.isNotEmpty) {
        for (var entry
            in physical[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in social.keys) {
      int id = await database.insert(
          'attributes', social[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (social[textId]!.specializations.isNotEmpty) {
        for (var entry
            in social[textId]!.specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (social[textId]!.levels.isNotEmpty) {
        for (var entry
            in social[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    for (var textId in mental.keys) {
      int id = await database.insert(
          'attributes', mental[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (mental[textId]!.specializations.isNotEmpty) {
        for (var entry
            in mental[textId]!.specializationsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_specializations', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (mental[textId]!.levels.isNotEmpty) {
        for (var entry
            in mental[textId]!.levelsToDatabase(id, 'attribute_id')!) {
          await database.insert('attribute_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }
}

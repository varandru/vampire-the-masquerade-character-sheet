import 'package:get/get.dart';
import 'common_logic.dart';

enum AttributeColumnType { Physical, Mental, Social }

class AttributesController extends GetxController {
  ComplexAbilityColumn physicalAttributes = ComplexAbilityColumn('Physical');
  ComplexAbilityColumn socialAttributes = ComplexAbilityColumn('Mental');
  ComplexAbilityColumn mentalAttributes = ComplexAbilityColumn('Social');

  void initializeFromConstants() {
    physicalAttributes.values.value = PhysicalAttributesColumn().attributes;
    socialAttributes.values.value = SocialAttributesColumn().attributes;
    mentalAttributes.values.value = MentalAttributesColumn().attributes;
  }

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

  void load(Map<String, dynamic> json, AttributeDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.physicalAttributesName.isNotEmpty) {
      physicalAttributes.name.value = dictionary.physicalAttributesName;
    }
    if (dictionary.socialAttributesName.isNotEmpty) {
      socialAttributes.name.value = dictionary.socialAttributesName;
    }
    if (dictionary.mentalAttributesName.isNotEmpty) {
      mentalAttributes.name.value = dictionary.mentalAttributesName;
    }

    _fillAttributeListByType(
        AttributeColumnType.Physical, json["physical"], dictionary);
    _fillAttributeListByType(
        AttributeColumnType.Mental, json["mental"], dictionary);
    _fillAttributeListByType(
        AttributeColumnType.Social, json["social"], dictionary);
  }

  void _fillAttributeListByType(AttributeColumnType type,
      List<dynamic> attributes, AttributeDictionary dictionary) {
    for (var attribute in attributes) {
      if (attribute["name"] != null && attribute is Map<String, dynamic>) {
        String name = attribute["name"];

        ComplexAbilityEntry? entry;

        switch (type) {
          case AttributeColumnType.Physical:
            entry = dictionary.physical[name];
            break;
          case AttributeColumnType.Mental:
            entry = dictionary.mental[name];
            break;
          case AttributeColumnType.Social:
            entry = dictionary.social[name];
            break;
        }

        if (entry == null) {
          // If a stat is not found, add an empty one
          entry = ComplexAbilityEntry();
          switch (type) {
            case AttributeColumnType.Physical:
              dictionary.physical[name] = entry;
              break;
            case AttributeColumnType.Mental:
              dictionary.mental[name] = entry;
              break;
            case AttributeColumnType.Social:
              dictionary.social[name] = entry;
              break;
          }
        }

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
            name: name,
            current: attribute["current"] ?? 1,
            min: 0,
            max: 5,
            specialization: attribute["specialization"] ?? "",
            description: entry.description ?? "",
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

  Map<String, dynamic> save() {
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

//CRUTCH: constants for debugging and web
class PhysicalAttributesColumn {
  final header = "Physical";

  final List<ComplexAbility> attributes = [
    ComplexAbility(name: "Strength", current: 1, isDeletable: false),
    ComplexAbility(
        name: "Dexterity",
        current: 5,
        specialization: "Lightning Reflexes",
        isDeletable: false),
    ComplexAbility(name: "Stamina", current: 2, isDeletable: false),
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    ComplexAbility(name: "Charisma", current: 1, isDeletable: false),
    ComplexAbility(name: "Manipulation", current: 1, isDeletable: false),
    ComplexAbility(name: "Appearance", current: 4, isDeletable: false),
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    ComplexAbility(name: "Perception", current: 1, isDeletable: false),
    ComplexAbility(
        name: "Intelligence",
        current: 5,
        specialization: "Analytical Thinking",
        isDeletable: false),
    ComplexAbility(
        name: "Wits",
        current: 4,
        specialization: "Adapt to others",
        isDeletable: false)
  ];
}

class AttributeDictionary {
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
    if (json["physical"] != null && json["physical"] is List) {
      for (var attribute in json["physical"]) {
        if (attribute["name"] == null) continue;
        physical[attribute["name"]] = ComplexAbilityEntry.fromJson(attribute);
      }
    }
    // 5. Get social attributes
    if (json["social"] != null && json["social"] is List) {
      for (var attribute in json["social"]) {
        if (attribute["name"] == null) continue;
        social[attribute["name"]] = ComplexAbilityEntry.fromJson(attribute);
      }
    }
    // 6. Get mental attributes
    if (json["mental"] != null && json["mental"] is List) {
      for (var attribute in json["mental"]) {
        if (attribute["name"] == null) continue;
        mental[attribute["name"]] = ComplexAbilityEntry.fromJson(attribute);
      }
    }
  }
}

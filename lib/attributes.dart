import 'package:get/get.dart';
import 'common_logic.dart';

enum AttributeColumnType { Physical, Mental, Social }

class AttributesController extends GetxController {
  RxList<ComplexAbility> physicalAttributes = RxList<ComplexAbility>();
  RxList<ComplexAbility> socialAttributes = RxList<ComplexAbility>();
  RxList<ComplexAbility> mentalAttributes = RxList<ComplexAbility>();

  final Map<AttributeColumnType, String> _headers = {
    AttributeColumnType.Physical: 'Physical',
    AttributeColumnType.Mental: 'Mental',
    AttributeColumnType.Social: 'Social',
  };

  void initializeFromConstants() {
    physicalAttributes.value = PhysicalAttributesColumn().attributes;
    socialAttributes.value = SocialAttributesColumn().attributes;
    mentalAttributes.value = MentalAttributesColumn().attributes;
  }

  String getHeaderByType(AttributeColumnType type) => _headers[type]!;

  List<ComplexAbility> getColumnByType(AttributeColumnType type) {
    switch (type) {
      case AttributeColumnType.Physical:
        return physicalAttributes;
      case AttributeColumnType.Mental:
        return mentalAttributes;
      case AttributeColumnType.Social:
        return socialAttributes;
    }
  }

  // Also, not here. App should move the assets with defaults, including dictionaries,
  // to it's working folder. I guess, it's done on installation.
  // Assets are pregens, not real files to work with
  void load(Map<String, dynamic> json, AttributeDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.physicalAttributesName.isNotEmpty) {
      _headers[AttributeColumnType.Physical] =
          dictionary.physicalAttributesName;
    }
    if (dictionary.socialAttributesName.isNotEmpty) {
      _headers[AttributeColumnType.Social] = dictionary.socialAttributesName;
    }
    if (dictionary.mentalAttributesName.isNotEmpty) {
      _headers[AttributeColumnType.Mental] = dictionary.mentalAttributesName;
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

        AttributeDictionaryEntry? entry;

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
          entry = AttributeDictionaryEntry();
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
          specialization: attribute["specialization"],
          description: entry.description ?? "",
          isIncremental: true, // Attributes are incremental, AFAIK
        );

        print(
            "Adding ability $type: '${ca.name}', ${ca.current}, '${ca.specialization}', '${ca.description}'");

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
    for (var attribute in column) {
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
    ComplexAbility(name: "Strength", current: 1),
    ComplexAbility(
        name: "Dexterity", current: 5, specialization: "Lightning Reflexes"),
    ComplexAbility(name: "Stamina", current: 2),
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    ComplexAbility(name: "Charisma", current: 1),
    ComplexAbility(name: "Manipulation", current: 1),
    ComplexAbility(name: "Appearance", current: 4),
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    ComplexAbility(name: "Perception", current: 1),
    ComplexAbility(
        name: "Intelligence",
        current: 5,
        specialization: "Analytical Thinking"),
    ComplexAbility(name: "Wits", current: 4, specialization: "Adapt to others")
  ];
}

// String name is not in the entry, it's a map key
class AttributeDictionaryEntry {
  // String name = "";
  List<String> specializations = [];
  List<String> level = [];
  String? description;
}

class AttributeDictionary {
  Map<String, AttributeDictionaryEntry> physical = Map();
  Map<String, AttributeDictionaryEntry> social = Map();
  Map<String, AttributeDictionaryEntry> mental = Map();

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
        physical[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
    // 5. Get social attributes
    if (json["social"] != null && json["social"] is List) {
      for (var attribute in json["social"]) {
        if (attribute["name"] == null) continue;
        social[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
    // 6. Get mental attributes
    if (json["mental"] != null && json["mental"] is List) {
      for (var attribute in json["mental"]) {
        if (attribute["name"] == null) continue;
        mental[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
  }

  AttributeDictionaryEntry _getAttributeFromJson(
      Map<String, dynamic> attribute) {
    AttributeDictionaryEntry entry = AttributeDictionaryEntry();
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
          entry.level.add(level);
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

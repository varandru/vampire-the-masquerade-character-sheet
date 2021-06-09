import 'package:get/get.dart';
import 'common_logic.dart';

enum AttributeColumnType { Physical, Mental, Social }

class AttributesController extends GetxController {
  final attributeListFile = 'default_attributes_en_US.json';

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

  // TODO: loading from dictionary, filling attributes with info.
  // Also, not here. App should move the assets with defaults, including dictionaries,
  // to it's working folder. I guess, it's done on installation.
  // Assets are pregens, not real files to work with
  void load(Map<String, dynamic> json, AttributeDictionary dictionary) {}

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

class AttributeDictionaryEntry {
  String name = "";
  List<String> specializations = [];
  List<String> level = [];
  String? description;

  bool loadFromJson(Map<String, dynamic> json) {
    if (json["name"] == null) return false;
    name = json["name"];
    if (json["specialization"] != null) {
      for (String specialization in json["specialization"]) {
        specializations.add(specialization);
      }
    }
    if (json["levels"] != null) {
      for (String levelDesc in json["levels"]) {
        level.add(levelDesc);
      }
    }
    description = json["description"];
    return true;
  }
}

class AttributeDictionary {
  List<AttributeDictionaryEntry> physical = [];
  List<AttributeDictionaryEntry> social = [];
  List<AttributeDictionaryEntry> mental = [];

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
      physicalAttributesName = json["physical"];
      socialAttributesName = json["social"];
      mentalAttributesName = json["mental"];
    }

    // 4. Get physical attributes
    if (json["physical"] != null && json["physical"] is List) {
      for (var attribute in json["physical"]) {
        physical.add(_getAttributeFromJson(attribute));
      }
    }
    // 5. Get social attributes
    if (json["social"] != null && json["social"] is List) {
      for (var attribute in json["social"]) {
        social.add(_getAttributeFromJson(attribute));
      }
    }
    // 6. Get mental attributes
    if (json["mental"] != null && json["mental"] is List) {
      for (var attribute in json["mental"]) {
        mental.add(_getAttributeFromJson(attribute));
      }
    }
  }

  AttributeDictionaryEntry _getAttributeFromJson(
      Map<String, dynamic> attribute) {
    // TODO: schema checking. On entry as well
    AttributeDictionaryEntry entry = AttributeDictionaryEntry();
    entry.name = attribute["name"];
    // Does this actually work?
    entry.specializations = attribute["specialization"] as List<String>;
    entry.level = attribute["levels"] as List<String>;
    entry.description = attribute["description"];

    return entry;
  }
}

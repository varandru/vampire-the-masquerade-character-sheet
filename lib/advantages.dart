import 'package:get/get.dart';
import 'common_logic.dart';

class BackgroundsController extends GetxController {
  RxList<ComplexAbility> backgrounds = RxList<ComplexAbility>();

  String header = 'Backgrounds';

  void initializeFromConstants() {
    backgrounds.value = [
      ComplexAbility(name: "Mentor", current: 2),
      ComplexAbility(name: "Herd", current: 1),
      ComplexAbility(name: "Resources", current: 2),
      ComplexAbility(name: "Generation", current: 3),
    ];
  }

  void load(List<dynamic> json, BackgroundDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.name.isNotEmpty) {
      header = dictionary.name;
    }

    _fillBackgroundList(json, dictionary);
  }

  void _fillBackgroundList(
      List<dynamic> attributes, BackgroundDictionary dictionary) {
    for (var attribute in attributes) {
      if (attribute["name"] != null && attribute is Map<String, dynamic>) {
        String name = attribute["name"];
        ComplexAbilityEntry? entry;
        entry = dictionary.backgrounds[name];

        if (entry == null) {
          // If a stat is not found, add an empty one
          entry = ComplexAbilityEntry();
          dictionary.backgrounds[name] = entry;
        }

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
          name: name,
          current: attribute["current"] ?? 1,
          min: 0,
          max: 5,
          specialization: "",
          description: entry.description ?? "",
          isIncremental: true, // Attributes are incremental, AFAIK
        );

        print(
            "Adding backgrounds: '${ca.name}', ${ca.current}, '${ca.description}'");

        if (!backgrounds.contains(ca)) {
          backgrounds.add(ca);
        }
      }
    }
  }

  List<Map<String, dynamic>> save() {
    List<Map<String, dynamic>> shortAttributes = [];
    for (var attribute in backgrounds) {
      Map<String, dynamic> attr = Map();
      attr["name"] = attribute.name;
      attr["current"] = attribute.current;
      attr["specialization"] = attribute.specialization;
      shortAttributes.add(attr);
    }
    return shortAttributes;
  }
}

class BackgroundDictionary {
  Map<String, ComplexAbilityEntry> backgrounds = Map();

  String name = "Backgrounds";

  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all

    // 2. Get attribute categories
    if (json["name"] != null) {
      name = json["name"];
    }

    // 4. Get physical attributes
    if (json["backgrounds"] != null && json["backgrounds"] is List) {
      for (var attribute in json["backgrounds"]) {
        if (attribute["name"] == null) continue;
        backgrounds[attribute["name"]] = _getAttributeFromJson(attribute);
      }
    }
  }

  ComplexAbilityEntry _getAttributeFromJson(Map<String, dynamic> attribute) {
    ComplexAbilityEntry entry = ComplexAbilityEntry();
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

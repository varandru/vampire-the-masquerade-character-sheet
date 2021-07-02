import 'package:get/get.dart';
import 'common_logic.dart';

class BackgroundsController extends GetxController {
  var backgrounds = ComplexAbilityColumn('Backgrounds').obs;

  void load(List<dynamic> json, BackgroundDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.name.isNotEmpty) {
      backgrounds.value.name.value = dictionary.name;
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
          isIncremental: true, // Backgrounds are incremental
          hasSpecialization: false,
        );

        backgrounds.value.add(ca);
      }
    }
  }

  List<Map<String, dynamic>> save() {
    List<Map<String, dynamic>> shortAttributes = [];
    for (var attribute in backgrounds.value.values) {
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
        backgrounds[attribute["name"]] =
            ComplexAbilityEntry.fromJson(attribute);
      }
    }
  }
}

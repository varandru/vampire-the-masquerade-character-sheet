import 'package:get/get.dart';
import 'common_logic.dart';

class BackgroundsController extends GetxController {
  var backgrounds = ComplexAbilityColumn('Backgrounds').obs;

  void initializeFromConstants() {
    backgrounds.value.values.value = [
      ComplexAbility(name: "Mentor", current: 2),
      ComplexAbility(name: "Herd", current: 1),
      ComplexAbility(name: "Resources", current: 2),
      ComplexAbility(name: "Generation", current: 3),
    ];
  }

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
        );

        print(
            "Adding backgrounds: '${ca.name}', ${ca.current}, '${ca.description}'");
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

class VirtuesController extends GetxController {
  var consience = 2.obs;
  var selfControl = 3.obs;
  var courage = 5.obs;

  var additionalHumanity = 0.obs;
  var additionalWillpower = 5.obs;

  int get humanity =>
      consience.value + selfControl.value + additionalHumanity.value;
  int get willpower => courage.value + additionalWillpower.value;

  void load(Map<String, dynamic> json) {
    consience.value = json["consience"] ?? 0;
    selfControl.value = json["self_control"] ?? 0;
    courage.value = json["courage"] ?? 0;

    additionalHumanity.value = json["additional_humanity"] ?? 0;
    additionalWillpower.value = json["additional_willpower"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["consience"] = consience.value;
    json["self_control"] = selfControl.value;
    json["courage"] = courage.value;

    json["additional_humanity"] = additionalHumanity.value;
    json["additional_willpower"] = additionalWillpower.value;
    return json;
  }
}

import 'package:get/get.dart';
import 'common_logic.dart';

class BackgroundsController extends GetxController {
  var backgrounds = ComplexAbilityColumn('Backgrounds').obs;

  void load(Map<String, dynamic> json, BackgroundDictionary dictionary) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    if (dictionary.name.isNotEmpty) {
      backgrounds.value.name.value = dictionary.name;
    }

    _fillBackgroundList(json, dictionary);
  }

  void _fillBackgroundList(
      Map<String, dynamic> attributes, BackgroundDictionary dictionary) {
    for (var id in attributes.keys) {
      if (attributes[id] != null && attributes[id] is Map<String, dynamic>) {
        ComplexAbilityEntry? entry;
        entry = dictionary.backgrounds[id];

        if (entry == null) {
          // If a stat is not found, add an empty one
          entry = ComplexAbilityEntry(name: id);
          dictionary.backgrounds[id] = entry;
          dictionary.changed = true;
        }

        // CRUTCH This doesn't allow attributes to go above 5
        ComplexAbility ca = ComplexAbility(
          id: id,
          name: entry.name,
          current: attributes[id]["current"] ?? 1,
          min: 0,
          max: 5,
          specialization: "",
          description: entry.description ?? "",
          isIncremental: true, // Backgrounds are incremental
          hasSpecialization: false,
        );

        print("Advantage: ${ca.name}, $id");

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

class BackgroundDictionary extends Dictionary {
  BackgroundDictionary(String file) : super(file);

  Map<String, ComplexAbilityEntry> backgrounds = Map();

  String name = "Backgrounds";

  @override
  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all

    // 2. Get attribute categories
    if (json["name"] != null) {
      name = json["name"];
    }

    // 4. Get backgrounds
    if (json["backgrounds"] != null &&
        json["backgrounds"] is Map<String, dynamic>) {
      Map<String, dynamic> entries = json["backgrounds"];

      for (var id in entries.keys) {
        if (entries[id] == null) {
          entries[id] = ComplexAbilityEntry(name: id);
        }
        backgrounds[id] = ComplexAbilityEntry.fromJson(entries[id]);
      }
    }
  }

  @override
  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();

    // CRUTCH until localization
    json["locale"] = "en-US";
    json["name"] = name;
    json["backgrounds"] = backgrounds;

    changed = false;

    return json;
  }
}

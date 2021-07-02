import 'package:get/get.dart';

String identify(String name) =>
    name.toLowerCase().replaceAll(' ', '_').replaceAll('[\\W0-9]', '');

class ComplexAbility {
  ComplexAbility({
    required this.name,
    this.current = 1,
    this.min = 0,
    this.max = 5,
    this.specialization = "",
    this.description = "",
    this.isIncremental = true,
    this.hasSpecialization = true,
    this.isDeletable = true,
    this.isNameEditable = true,
  });
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;

  /// Does this ability get directly better at higher levels?
  /// If there is variety, this is false
  bool isIncremental;

  /// Can this ability have a specialization? Generally hardcoded
  /// Backgrounds don't have it, most other things do
  bool hasSpecialization;

  /// Can this ability be deleted?
  /// Attributes can't. Abilities can. Backgrounds sure as hell can
  bool isDeletable;

  /// Can this ability's name be edited?
  /// Virtues can't. All the rest can.
  bool isNameEditable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplexAbility && other.name == this.name);

  @override
  int get hashCode => name.hashCode;

  ComplexAbility.fromJson(
    Map<String, dynamic> json, {
    this.hasSpecialization = true,
    this.isDeletable = true,
  })  : name = json['name'],
        current = json['current'],
        specialization = json['specialization'] ?? "",
        description = "",
        min = 1,
        max = 5,
        isIncremental = true,
        isNameEditable = true;

  void fillFromDictionary(ComplexAbilityEntry entry) {
    // levelDescriptions = entry.levels;
    if (entry.description != null) description = entry.description!;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['name'] = name;
    json['current'] = current;
    if (specialization.isNotEmpty) json['specialization'] = specialization;
    return json;
  }
}

// String name is not in the entry, it's a map key
class ComplexAbilityEntry {
  // String name = "";
  List<String> specializations = [];
  List<String> levels = [];
  String? description;

  ComplexAbilityEntry.fromJson(Map<String, dynamic> json) {
    if (json["specialization"] != null) {
      if (json["specialization"] is List) {
        for (var specialization in json["specialization"]) {
          specializations.add(specialization);
        }
      }
    }
    if (json["levels"] != null) {
      if (json["levels"] is List) {
        for (var level in json["levels"]) {
          levels.add(level);
        }
      }
    }
    description = json["description"];
  }

  ComplexAbilityEntry(
      {this.specializations = const [],
      this.levels = const [],
      this.description});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    // json['name'] = name;
    if (description != null) json['description'] = description;
    if (specializations.isNotEmpty) json['specializations'] = specializations;
    return json;
  }
}

class ComplexAbilityColumn {
  ComplexAbilityColumn(String name) {
    this.name.value = name;
  }

  var name = "Name".obs;
  RxList<ComplexAbility> values = RxList();

  void sortByName() {
    values.sort((a1, a2) => a1.name.compareTo(a2.name));
  }

  void editValue(ComplexAbility value, ComplexAbility old) {
    values[values.indexOf(old)] = value;
    if (value.isDeletable) sortByName();
  }

  void deleteValue(ComplexAbility value) {
    print("Tried to delete ${value.name}");
    values.remove(value);
    if (value.isDeletable) sortByName();
  }

  void add(ComplexAbility ca) {
    if (!values.contains(ca)) {
      values.add(ca);
    } else {
      values[values.indexOf(ca)] = ca;
    }
    if (ca.isDeletable) sortByName();
  }

  List<dynamic> toJson() {
    return values;
  }
}

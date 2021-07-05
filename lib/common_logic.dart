import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

String identify(String name) =>
    name.toLowerCase().replaceAll(' ', '_').replaceAll('[\\W0-9]', '');

class ComplexAbility {
  ComplexAbility({
    required this.id,
    required this.name,
    this.current = 1,
    this.min = 0,
    this.max = 5,
    // this.specialization = "",
    // this.description = "",
    this.isIncremental = true,
    this.hasSpecialization = true,
    this.isDeletable = true,
    this.isNameEditable = true,
  });

  final String id;
  String name;
  int current;
  int min;
  int max;
  // Pull these from DB
  // String specialization;
  // String description;

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
  })  : id = json["id"],
        name = "",
        current = json['current'],
        specialization = json['specialization'] ?? "",
        description = "",
        min = 1,
        max = 5,
        isIncremental = true,
        isNameEditable = true;

  ComplexAbility.fromOther(this.id, ComplexAbility other)
      : name = other.name,
        current = other.current,
        min = other.min,
        max = other.max,
        specialization = other.specialization,
        description = other.description,
        isIncremental = other.isIncremental,
        hasSpecialization = other.isIncremental,
        isDeletable = other.isDeletable,
        isNameEditable = other.isNameEditable;

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

// String id is not in the entry, it's a map key
class ComplexAbilityEntry {
  String name = "";
  List<String> specializations = [];
  List<String> levels = [];
  String? description;

  ComplexAbilityEntry.fromJson(Map<String, dynamic> json) {
    name = json["name"];

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
      {required this.name,
      this.specializations = const [],
      this.levels = const [],
      this.description});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    json['name'] = name;
    if (description != null) json['description'] = description;
    if (specializations.isNotEmpty) json['specializations'] = specializations;
    if (levels.isNotEmpty) json["levels"] = levels;

    return json;
  }
}

class ComplexAbilityColumn {
  ComplexAbilityColumn(String name) {
    this.name.value = name;
  }

  var name = "Name".obs;
  RxList<ComplexAbility> values = RxList();

  void sortById() {
    values.sort((a1, a2) => a1.id.compareTo(a2.id));
  }

  void editValue(ComplexAbility value, ComplexAbility old) {
    values[values.indexOf(old)] = value;
    if (value.isDeletable) sortById();
  }

  void deleteValue(ComplexAbility value) {
    values.remove(value);
    if (value.isDeletable) sortById();
  }

  void add(ComplexAbility ca) {
    if (!values.contains(ca)) {
      values.add(ca);
    } else {
      values[values.indexOf(ca)] = ca;
    }
    if (ca.isDeletable) sortById();
  }

  Map<String, dynamic> toJson() {
    return Map.fromIterable(
      values,
      key: (value) => value.id,
      value: (value) => value.toJson(),
    );
  }
}

abstract class Dictionary {
  Dictionary(this.fileName) {
    File dictionaryFile = File(this.fileName);
    if (dictionaryFile.existsSync()) {
      load(jsonDecode(dictionaryFile.readAsStringSync()));
    } else {
      throw ("Attribute dictionary $dictionaryFile does not exist");
    }
  }

  bool changed = false;
  final String fileName;

  void load(Map<String, dynamic> json);

  Map<String, dynamic> save();

  onDispose() async {
    if (changed) {
      File dictionaryFile = File(fileName);
      if (await dictionaryFile.exists()) {
        dictionaryFile.writeAsStringSync(jsonEncode(save()));
      } else {
        throw ("Dictionary file $dictionaryFile does not exist");
      }
    }
  }
}

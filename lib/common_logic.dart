import 'dart:convert';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

String identify(String name) =>
    name.toLowerCase().replaceAll(' ', '_').replaceAll('[\\W0-9]', '');

class ComplexAbility {
  ComplexAbility({
    required this.id,
    required this.name,
    this.txtId,
    this.current = 1,
    this.min = 0,
    this.max = 5,
    this.specialization = "",
    this.isIncremental = true,
    this.hasSpecialization = true,
    this.isDeletable = true,
    this.isNameEditable = true,
  });

  final int? id;
  final String? txtId;
  String name;
  int current;
  int min;
  int max;
  String specialization;

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
  })  : txtId = json["id"],
        id = null,
        name = "",
        current = json['current'],
        specialization = json['specialization'] ?? "",
        min = 1,
        max = 5,
        isIncremental = true,
        isNameEditable = true;

  ComplexAbility.fromOther(this.txtId, ComplexAbility other)
      : name = other.name,
        id = other.id,
        current = other.current,
        min = other.min,
        max = other.max,
        specialization = other.specialization,
        isIncremental = other.isIncremental,
        hasSpecialization = other.hasSpecialization,
        isDeletable = other.isDeletable,
        isNameEditable = other.isNameEditable;

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
  int? databaseId;

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

  Map<String, Object?> toDatabaseMap(String id) =>
      {"txt_id": id, "name": name, "description": description};

  List<Map<String, Object?>>? specializationsToDatabase(
          int foreignKey, String foreignKeyName) =>
      specializations.isEmpty
          ? null
          : List.generate(
              specializations.length,
              (index) =>
                  {foreignKeyName: foreignKey, "name": specializations[index]});

  List<Map<String, Object?>>? levelsToDatabase(
          int foreignKey, String foreignKeyName) =>
      levels.isEmpty
          ? null
          : List.generate(
              levels.length,
              (index) => {
                    foreignKeyName: foreignKey,
                    'description': levels[index],
                    'level': index + 1
                  });
}

class ComplexAbilityEntryDatabaseDescription {
  ComplexAbilityEntryDatabaseDescription({
    required this.tableName,
    required this.fkName,
    required this.playerLinkTable,
    this.specializationsTable,
    this.filter,
  });

  /// Table from which the main information is pulled
  String tableName;

  /// Table from which the specializations are pulled (if applicable)
  String? specializationsTable;

  /// Table, from which level descriptions will be pulled
  /// When I get to them...
  // String? levels

  /// Foreign key name. E.x. attribute_id
  String fkName;

  /// Table that links entries to characters. E.x. player_attributes
  String playerLinkTable;

  /// Additional filter, if applicable. 0, 1, 2 for attribute type, for example
  int? filter;
}

class ComplexAbilityColumn {
  ComplexAbilityColumn(String name, {required this.description}) {
    this.name.value = name;
  }

  final ComplexAbilityEntryDatabaseDescription description;

  var name = "Name".obs;
  RxList<ComplexAbility> values = RxList();

  void sortById() {
    values.sort((a1, a2) {
      if (a1.id == null && a2.id == null)
        return a1.txtId?.compareTo(a2.txtId ?? '') ?? 0;
      else if (a1.id == null)
        return -1;
      else if (a2.id == null)
        return 1;
      else
        return a1.id!.compareTo(a2.id!);
    });
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
  Dictionary(final String json) {
    load(jsonDecode(json));
  }

  bool changed = false;
  void load(Map<String, dynamic> json);

  Map<String, dynamic> save();

  /// Legal dynamics map to TEXT, INTEGER, REAL, BLOB, NULL. How am I going to insert arrays? Great question
  Future<void> loadAllToDatabase(Database database);
}

class ComplexAbilityPair {
  ComplexAbilityPair(this.ability, this.entry);

  ComplexAbility ability;
  ComplexAbilityEntry entry;
}

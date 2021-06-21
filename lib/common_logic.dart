import 'package:get/get.dart';

class ComplexAbility {
  ComplexAbility(
      {required this.name,
      this.current = 1,
      this.min = 0,
      this.max = 5,
      this.specialization = "",
      this.description = "",
      this.levelDescriptions,
      this.isIncremental = true});
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;
  List<String>? levelDescriptions = [];

  /// Does this ability get directly better at higher levels?
  /// If there is variety, this is false
  bool isIncremental;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplexAbility && other.name == this.name);

  @override
  int get hashCode => name.hashCode;

  ComplexAbility.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        current = json['current'],
        specialization = json['specialization'] ?? "",
        description = "",
        min = 1,
        max = 5,
        isIncremental = true;

  void fillFromDictionary(ComplexAbilityEntry entry) {
    levelDescriptions = entry.levels;
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

  RxList<ComplexAbility> values = RxList();

  var name = "Name".obs;

  void editValue(ComplexAbility value, int index) {
    values[index] = value;
  }

  void add(ComplexAbility ca) {
    if (!values.contains(ca)) {
      values.add(ca);
    }
  }
}

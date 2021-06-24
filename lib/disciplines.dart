import 'package:get/get.dart';

class Discipline {
  Discipline(
      {required this.name,
      required this.level,
      this.description,
      this.max = 5});

  Discipline.fromDictionary(
      {required Discipline base, required DisciplineEntry entry})
      : name = base.name,
        level = base.level,
        description = base.description ?? entry.description,
        max = entry.max;

  String name;
  String? description;

  int level;
  int max;
}

class DisciplineIncremental extends Discipline {
  DisciplineIncremental(
      {required String name,
      required int level,
      required this.system,
      String? description,
      int max = 5})
      : super(name: name, level: level, description: description, max: max);

  DisciplineIncremental.fromDictionary(
      {required Discipline base, required DisciplineEntryIncremental entry})
      : system = entry.system,
        super.fromDictionary(base: base, entry: entry);

  String system;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discipline && other.name == this.name);

  @override
  int get hashCode => name.hashCode;
}

class DisciplineLevels extends Discipline {
  DisciplineLevels(
      {required String name,
      required int level,
      required this.levels,
      String? description,
      int max = 5})
      : super(name: name, level: level, description: description, max: max);

  DisciplineLevels.fromDictionary(
      {required Discipline base, required DisciplineEntryLevels entry})
      : levels = [],
        super.fromDictionary(base: base, entry: entry) {
    entry.levels.forEach((key, value) => levels.add(value));
  }

  List<DisciplineDot> levels;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discipline && other.name == this.name);

  @override
  int get hashCode => name.hashCode;
}

// TODO: display the table
class DisciplineDot {
  DisciplineDot(
      {required this.name,
      required this.level,
      this.system = "",
      this.max = 5,
      this.description});

  String name;
  String? description;
  String system;

  int level;
  int max;

  DisciplineDot.fromJson(Map<String, dynamic> json)
      : name = json["name"]!,
        description = json["description"],
        level = json["level"]!,
        system = json["system"]!,
        max = json["max"] ?? 5;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    json["name"] = name;
    json["description"] = description;
    json["level"] = level;
    json["system"] = system;
    json["max"] = max;

    return json;
  }
}

class DisciplineController extends GetxController {
  RxList<Discipline> disciplines = RxList();

  void load(List<dynamic> json, DisciplineDictionary dictionary) {
    for (var discipline in json) {
      if (discipline["name"] == null)
        throw ("$discipline lacks neccessary fields");
      if (discipline["level"] == null)
        throw ("$discipline lacks neccessary fields");

      var entry = dictionary.entries[discipline["name"]];

      if (entry == null) {
        throw ("Discipline ${discipline["name"]} not found, add it to dictionary");
      } else if (entry is DisciplineEntryIncremental) {
        Discipline base = Discipline(
          name: discipline["name"],
          level: discipline["level"],
        );
        if (!disciplines.contains(base)) {
          disciplines.add(DisciplineIncremental.fromDictionary(
            base: base,
            entry: entry,
          ));
        }
      } else if (entry is DisciplineEntryLevels) {
        Discipline base = Discipline(
          name: discipline["name"],
          level: discipline["level"],
        );
        if (!disciplines.contains(base)) {
          disciplines.add(DisciplineLevels.fromDictionary(
            base: base,
            entry: entry,
          ));
        }
      } else {
        throw ("Discipline ${discipline["name"]} has unrecognized type");
      }
    }
  }

  List<dynamic> save() {
    // If this actually works, bless JSON
    return disciplines;
  }

  void edit(Discipline value, int index) {
    disciplines[index] = value;
  }

  void deleteAt(int index) {
    disciplines.removeAt(index);
  }
}

class DisciplineEntry {
  // String name; Map key
  String? description;
  int max = 5;

  DisciplineEntry.fromJson(Map<String, dynamic> json) {
    if (json["description"] != null) description = json["description"];
    if (json["max"] != null) max = json["max"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["description"] = description;
    return json;
  }
}

class DisciplineEntryIncremental extends DisciplineEntry {
  late String system;

  DisciplineEntryIncremental.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json["system"] == null)
      throw ("${json["name"]} is missing mandatory field: system");
    else
      system = json["system"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json["is_incremental"] = true;
    json["system"] = system;
    return json;
  }
}

class DisciplineEntryLevels extends DisciplineEntry {
  Map<int, DisciplineDot> levels = Map();

  DisciplineEntryLevels.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    for (var level in json["levels"]) {
      if (level["level"] == null) throw ("$level does not have a level");
      levels[level["level"]] = DisciplineDot.fromJson(level);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json["is_incremental"] = true;
    json["levels"] = levels;
    return json;
  }
}

class DisciplineDictionary {
  Map<String, DisciplineEntry> entries = Map();

  DisciplineDictionary.fromJson(Map<String, dynamic> json) {
    if (json["disciplines"] != null && json["disciplines"] is List) {
      for (var discipline in json["disciplines"]) {
        String? name = discipline["name"];
        if (name == null) {
          throw ("Discipline $discipline is missing a required field");
        }
        if (discipline["is_incremental"])
          entries[name] = DisciplineEntryIncremental.fromJson(discipline);
        else
          entries[name] = DisciplineEntryLevels.fromJson(discipline);
        print(
            "Discipline entry: '$name', ${entries[name] is DisciplineEntryIncremental}");
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    List<dynamic> disciplines = [];
    for (var discipline in entries.entries) {
      Map<String, dynamic> entry = discipline.value.toJson();
      entry["name"] = discipline.key;
      disciplines.add(discipline);
    }
    json["locale"] = "en-US";
    json["disciplines"] = disciplines;
    return json;
  }
}

import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';

class Discipline {
  Discipline(
      {required this.id,
      this.name = "",
      required this.level,
      this.description,
      this.levels,
      this.system,
      this.max = 5});

  Discipline.fromDictionary(
      {required Discipline base, required DisciplineEntry entry})
      : id = base.id,
        level = base.level,
        description = base.description ?? entry.description,
        name = entry.name,
        max = entry.max {
    if (entry.system != null) {
      system = entry.system;
      isIncremental = true;
    }
    if (entry.levels != null) {
      levels = [];
      entry.levels!.forEach((key, value) => levels!.add(value));
      isIncremental = false;
    }
    if (isIncremental == null) {
      throw ("Either general or specific system must be present in discipline $name");
    }
    print("Added discipline $name");
  }

  Discipline.fromOther(String id, Discipline other)
      : this.id = id,
        name = other.name,
        description = other.description,
        level = other.level,
        max = other.max,
        isIncremental = other.isIncremental,
        system = other.system,
        levels = other.levels;

  final String id;
  String name;
  String? description;

  int level;
  int max;

  bool? isIncremental;

  String? system;
  List<DisciplineDot>? levels;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['name'] = name;
    json['level'] = level;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Discipline && other.id == this.id);

  @override
  int get hashCode => id.hashCode;

  void updateDot(DisciplineDot dot, int index) {
    levels![index] = dot;
  }

  void addDot(DisciplineDot dot) {
    if (levels == null)
      levels = [dot];
    else
      levels!.add(dot);
  }

  void removeDot(int index) {
    if (index < levels!.length) levels!.removeAt(index);
  }
}

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

  /// Is max even used?
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

  void copy(DisciplineDot other) {
    name = other.name;
    description = other.description;
    system = other.system;
    level = other.level;
    max = other.max;
  }

  Map<String, Object?> toDatabase(int foreignKey) => {
        'discipline_id': foreignKey,
        'level': level,
        'system': system,
        'maximum': max,
        'description': description,
      };
}

class DisciplineController extends GetxController {
  RxList<Discipline> disciplines = RxList();

  void load(Map<String, dynamic> json, DisciplineDictionary dictionary) {
    for (var id in json.keys) {
      if (json[id] == null) throw ("Invalid JSON $json");
      if (json[id]["current"] == null)
        throw ("${json["id"]} lacks neccessary fields");

      var entry = dictionary.entries[id];

      if (entry != null) {
        Discipline base = Discipline(
          id: id,
          level: json[id]["current"],
        );
        if (!disciplines.contains(base)) {
          try {
            disciplines.add(Discipline.fromDictionary(
              base: base,
              entry: entry,
            ));
          } catch (e) {
            continue;
          }
        }
      }
    }
  }

  List<dynamic> save() => disciplines;

  void edit(Discipline value, int index) {
    disciplines[index] = value;
  }

  void deleteAt(int index) {
    disciplines.removeAt(index);
  }
}

// String id is the map key
class DisciplineEntry {
  late String name;
  String? description;

  /// Is max even used?
  int max = 5;

  String? system;
  Map<int, DisciplineDot>? levels;

  DisciplineEntry.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    if (json["description"] != null) description = json["description"];
    if (json["max"] != null) max = json["max"];
    if (json["system"] != null) system = json["system"];

    if (json["levels"] != null) {
      levels = Map();
      for (var level in json["levels"]) {
        if (level["level"] == null) throw ("$level does not have a level");
        levels![level["level"]] = DisciplineDot.fromJson(level);
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["description"] = description;
    if (system != null) json["system"] = system;
    if (levels != null) json["levels"] = levels;
    return json;
  }

  Map<String, Object?> toDatabase(String id) => {
        'txt_id': id,
        'description': description,
        'maximum': max,
        'system': system
      };
}

class DisciplineDictionary extends Dictionary {
  DisciplineDictionary(String file) : super(file);

  Map<String, DisciplineEntry> entries = Map();

  @override
  Map<String, dynamic> save() {
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

  @override
  void load(Map<String, dynamic> json) {
    if (json["disciplines"] != null &&
        json["disciplines"] is Map<String, dynamic>) {
      Map<String, dynamic> disciplineEntries = json["disciplines"];
      for (var id in disciplineEntries.keys) {
        entries[id] = DisciplineEntry.fromJson(disciplineEntries[id]);
      }
    }
  }

  @override
  void loadAllToDatabase(Database database) async {
    for (var entry in entries.entries) {
      int id = await database.insert(
          'disciplines', entry.value.toDatabase(entry.key),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (entry.value.levels != null) {
        for (var dot in entry.value.levels!.values) {
          await database.insert('discipline_levels', dot.toDatabase(id),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }
}

import 'package:get/get.dart';

class Discipline {
  Discipline(
      {required this.name,
      required this.level,
      this.description,
      this.levels,
      this.system,
      this.max = 5});

  Discipline.fromDictionary(
      {required Discipline base, required DisciplineEntry entry})
      : name = base.name,
        level = base.level,
        description = base.description ?? entry.description,
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
      identical(this, other) ||
      (other is Discipline && other.name == this.name);

  @override
  int get hashCode => name.hashCode;

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

      if (entry != null) {
        // throw ("Discipline ${discipline["name"]} not found, add it to dictionary");
        // } else {
        Discipline base = Discipline(
          name: discipline["name"],
          level: discipline["level"],
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

class DisciplineEntry {
  // String name; Map key
  String? description;
  int max = 5;

  String? system;
  Map<int, DisciplineDot>? levels;

  DisciplineEntry.fromJson(Map<String, dynamic> json) {
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
}

class DisciplineDictionary {
  Map<String, DisciplineEntry> entries = Map();

  DisciplineDictionary.fromJson(Map<String, dynamic> json) {
    if (json["disciplines"] != null && json["disciplines"] is List) {
      for (var discipline in json["disciplines"]) {
        String? name = discipline["name"];
        if (name == null) {
          throw ("Discipline $discipline is missing a name");
        }
        entries[name] = DisciplineEntry.fromJson(discipline);
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

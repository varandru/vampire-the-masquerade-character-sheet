import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

import 'disciplines.dart';
import 'common_logic.dart';

/// To fill a ritual
/// 1. Create an empty one, initialize with id
/// 2. Fill the info with @fromJson method
/// 3. Fill the school name by it's id
class Ritual {
  Ritual({
    required this.id,
    required this.dbId,
    this.name = "",
    this.schoolId,
    this.school = "",
    this.level = 1,
    this.description = "",
    this.system = "",
  });
  final String? id;
  final int? dbId;
  int level;
  String name;
  String school;
  int? schoolId;
  String? description;
  String system;

  void copy(Ritual other) {
    level = other.level;
    name = other.name;
    school = other.school;
    schoolId = other.schoolId;
    description = other.description;
    system = other.system;
  }

  /// IMPORTANT this is for Dictionary
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    json["level"] = level;
    json["name"] = name;
    json["id"] = id;
    json["school_id"] = schoolId;
    json["description"] = description;
    json["system"] = system;

    return json;
  }

  void fromJson(Map<String, dynamic> json) {
    level = json["level"];
    name = json["name"];
    schoolId = json["school_id"] ?? "undefined";
    description = json["description"];
    system = json["system"] ?? "";
  }

  void fromEntry(RitualEntry entry) {
    level = entry.level;
    name = entry.name;
    schoolId = entry.disciplineId;
    description = entry.description;
    system = entry.system;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ritual && other.id == this.id);

  @override
  int get hashCode => id.hashCode;
}

/// Ritual Entry does not exist here. It contains the same
/// information as a basic ritual, so we're just pulling only the
///  neccessary ones from JSon dictionary
class RitualController extends GetxController {
  RxList<Ritual> rituals = RxList();

  Map<String, dynamic> save() {
    return Map.fromIterable(rituals,
        key: (value) => value.id,
        value: (value) => {
              "name": value.name,
              "level": value.level,
              "school_id": value.schoolId,
              "description": value.description,
              "system": value.system
            });
  }

  void load(
      List<dynamic> ids, RitualDictionary dictionary, DisciplineDictionary dd) {
    for (var id in ids) {
      var ritual = Ritual(id: id, dbId: null);
      if (dictionary.entries[ritual.id] != null) {
        ritual.fromEntry(dictionary.entries[id]!);
        ritual.school = dd.entries[ritual.schoolId]?.name ?? "Undefined";
        if (!rituals.contains(ritual)) rituals.add(ritual);
      }
    }
  }

  Future<void> fromDatabase(Database database) async {
    rituals.value = await database.rawQuery(
        'select r.id, r.name, r.level, r.system, r.description, '
        'rl.name as discipline_name '
        'from rituals r '
        'inner join player_rituals pr on pr.ritual_id = r.id '
        'left join ritual_levels rl on rl.id = r.discipline_id '
        'where pr.player_id = ?',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Ritual(
              id: null,
              dbId: value[0]['id'] as int,
              name: value[0]['name'] as String,
              level: value[0]['level'] as int,
              school: value[0]['discipline_name'] as String? ?? 'Undefined',
              system: value[0]['system'] as String,
              description: value[0]['description'] as String,
            )));
  }
}

class RitualEntry {
  RitualEntry.fromJson(Map<String, dynamic> json)
      : level = json["level"],
        name = json["name"],
        schoolId = json["school_id"],
        description = json[" description"],
        system = json["system"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    json["level"] = level;
    json["name"] = name;
    json["school_id"] = schoolId;
    json["description"] = description;
    json["system"] = system;

    return json;
  }

  Map<String, Object?> toDatabase(String id) => {
        'txt_id': id,
        'name': name,
        'discipline_id': disciplineId,
        'level': level,
        'description': description,
        'system': system,
      };

  int level;
  String name;
  String school = 'Undefined';
  String? schoolId;
  int? disciplineId;
  String? description;
  String system;
}

class RitualDictionary extends Dictionary {
  RitualDictionary(String file) : super(file);

  Map<String, RitualEntry> entries = Map();

  @override
  void load(Map<String, dynamic> json) {
    // locale goes here
    for (var id in json["rituals"].keys) {
      entries[id] = RitualEntry.fromJson(json["rituals"][id]);
    }
  }

  @override
  Map<String, dynamic> save() {
    return Map.fromEntries(entries.entries);
  }

  @override
  Future<void> loadAllToDatabase(Database database) async {
    for (var entry in entries.entries) {
      if (entry.value.disciplineId == null) {
        var response = await database.query('disciplines',
            columns: ['id', 'name'],
            where: 'txt_id = ?',
            whereArgs: [entry.value.schoolId]);
        if (response.length > 0) {
          entry.value.disciplineId = response[0]['id'] as int? ?? -1;
          entry.value.school = response[0]['name'] as String? ?? 'Undefined';
        } else {
          entry.value.school = 'Undefined';
        }
      }
      await database.insert('rituals', entry.value.toDatabase(entry.key),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}

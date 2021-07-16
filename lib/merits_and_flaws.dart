import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';

import 'database.dart';

enum MeritType { Physical, Mental, Social, Supernatural, Undefined }

String meritName(MeritType type) {
  switch (type) {
    case MeritType.Physical:
      return "Physical";
    case MeritType.Mental:
      return "Mental";
    case MeritType.Social:
      return "Social";
    case MeritType.Supernatural:
      return "Supernatural";
    default:
      return "Undefined";
  }
}

MeritType typeFromString(String? name) {
  if (name == "physical") return MeritType.Physical;
  if (name == "mental") return MeritType.Mental;
  if (name == "social") return MeritType.Social;
  if (name == "supernatural") return MeritType.Supernatural;
  return MeritType.Undefined;
}

int intFromType(MeritType type) {
  switch (type) {
    case MeritType.Physical:
      return 1;
    case MeritType.Mental:
      return 2;
    case MeritType.Social:
      return 3;
    case MeritType.Supernatural:
      return 4;
    case MeritType.Undefined:
      return 0;
  }
}

MeritType typeFromInt(int type) {
  switch (type) {
    case 1:
      return MeritType.Physical;
    case 2:
      return MeritType.Mental;
    case 3:
      return MeritType.Social;
    case 4:
      return MeritType.Supernatural;
    default:
      return MeritType.Undefined;
  }
}

class Merit {
  Merit(
      {required this.id,
      required this.name,
      this.txtId,
      this.type = MeritType.Undefined,
      this.cost = 1,
      this.description = ""});

  int id;
  String? txtId;
  String name;
  MeritType type;
  int cost;
  String description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Merit && other.name == this.name);

  @override
  int get hashCode => name.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["name"] = name;
    json["cost"] = cost;
    return json;
  }
}

class MeritsAndFlawsController extends GetxController {
  RxList<Merit> merits = RxList();
  RxList<Merit> flaws = RxList();

  var meritSum = 0.obs;
  var flawsSum = 0.obs;

  void loadMerits(List<dynamic> json, MeritsAndFlawsDictionary dictionary) {
    // TODO: json contains ids. Basic merits should be loaded
    for (var merit in json) {
      if (merit["name"] == null) continue;
      if (!(merit["name"] is String)) continue;
      String name = merit["name"];
      if (dictionary.merits[name] == null) {
        continue;
      }
      int cost = dictionary.merits[name]!.costs.length > 0
          ? merit["cost"] ?? dictionary.merits[name]!.costs[0]
          : 1;
      Merit m = Merit(
        id: 0,
        name: merit["name"]!,
        type: dictionary.merits[name]!.type,
        cost: cost,
        description: dictionary.merits[name]?.description ?? "",
      );

      if (!merits.contains(m)) {
        merits.add(m);
        meritSum.value += m.cost;
      }
    }
  }

  void loadFlaws(List<dynamic> json, MeritsAndFlawsDictionary dictionary) {
    for (var flaw in json) {
      if (flaw["name"] == null) continue;
      if (!(flaw["name"] is String)) continue;
      String name = flaw["name"];
      if (dictionary.flaws[name] == null) {
        continue;
      }
      int cost = dictionary.flaws[name]!.costs.length > 0
          ? flaw["cost"] ?? dictionary.flaws[name]!.costs[0]
          : 1;
      Merit m = Merit(
        id: 0,
        name: flaw["name"]!,
        type: dictionary.flaws[name]!.type,
        cost: cost,
        description: dictionary.flaws[name]?.description ?? "",
      );

      if (!flaws.contains(m)) {
        flaws.add(m);
        flawsSum.value += m.cost;
      }
    }
  }

  List<dynamic> saveMerits() {
    List<dynamic> merits = [];
    for (var m in this.merits) {
      merits.add(m.toJson());
    }
    return merits;
  }

  List<dynamic> saveFlaws() {
    List<dynamic> flaws = [];
    for (var f in this.flaws) {
      flaws.add(f.toJson());
    }
    return flaws;
  }

  Future<void> fromDatabase(Database database) async {
    merits.value = await database.rawQuery(
        'select m.id, m.name, m.type, m.description, pm.cost '
        'from merits m '
        'inner join player_merits pm on pm.merit_id = m.id '
        'where pm.player_id = ?',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Merit(
              id: value[0]['id'] as int,
              name: value[0]['name'] as String,
              cost: value[0]['cost'] as int,
              type: typeFromInt(value[0]['type'] as int),
              description: value[0]['description'] as String,
            )));
    flaws.value = await database.rawQuery(
        'select f.id, f.name, f.type, f.description, pf.cost '
        'from flaws f '
        'inner join player_flaws pf on pf.flaw_id = f.id '
        'where pf.player_id = ?',
        [
          Get.find<DatabaseController>().characterId.value
        ]).then((value) => List.generate(
        value.length,
        (index) => Merit(
              id: value[0]['id'] as int,
              name: value[0]['name'] as String,
              cost: value[0]['cost'] as int,
              type: typeFromInt(value[0]['type'] as int),
              description: value[0]['description'] as String,
            )));
  }
}

class MeritEntry {
  MeritEntry(
      {required this.name,
      required this.type,
      this.costs = const [],
      this.description,
      this.databaseId});

  // Map key
  final String name;
  final MeritType type;
  late final List<int> costs;
  final String? description;
  int? databaseId;

  MeritEntry.fromJson(Map<String, dynamic> json)
      : type = typeFromString(json["type"]!),
        name = json["name"]!,
        description = json["description"] {
    if (json["cost"] != null) {
      List<int> c = [];
      for (var cost in json["cost"]) {
        c.add(cost);
      }
      costs = c;
    } else {
      costs = [];
    }
  }

  Map<String, Object?> toDatabase(String id) => {
        'txt_id': id,
        'name': name,
        'description': description,
      };
}

class MeritsAndFlawsDictionary extends Dictionary {
  MeritsAndFlawsDictionary(String file) : super(file);

  Map<String, MeritEntry> merits = Map();
  Map<String, MeritEntry> flaws = Map();

  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all
    // 2. Get merits
    if (json["merits"] != null && json["merits"] is List) {
      for (var m in json["merits"]) {
        if (m["name"] != null) {
          var merit = MeritEntry.fromJson(m);
          merits[m["name"]] = merit;
        }
      }
    }
    // 3. Get flaws
    if (json["flaws"] != null && json["flaws"] is List) {
      for (var f in json["flaws"]) {
        if (f["name"] != null) {
          var flaw = MeritEntry.fromJson(f);
          flaws[f["name"]] = flaw;
        }
      }
    }
  }

  @override
  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();

    return json;
  }

  @override
  Future<void> loadAllToDatabase(Database database) async {
    for (var merit in merits.entries) {
      int id = await database.insert(
          'merits', merit.value.toDatabase(merit.key),
          conflictAlgorithm: ConflictAlgorithm.rollback);
      for (var cost in merit.value.costs) {
        await database.insert('merit_costs', {'merit_id': id, 'cost': cost});
      }
      merit.value.databaseId = id;
    }
    for (var flaw in flaws.entries) {
      int id = await database.insert('flaws', flaw.value.toDatabase(flaw.key),
          conflictAlgorithm: ConflictAlgorithm.rollback);
      for (var cost in flaw.value.costs) {
        await database.insert('flaw_costs', {'flaw_id': id, 'cost': cost});
      }
    }
  }
}

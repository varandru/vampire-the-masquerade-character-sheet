import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';

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

class Merit {
  Merit(
      {required this.name,
      this.type = MeritType.Undefined,
      this.cost = 1,
      this.description = ""});

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
}

class MeritEntry {
  MeritEntry({
    required this.type,
    this.costs = const [],
    this.description,
  });

  // Map key
  // final String name;
  final MeritType type;
  late final List<int> costs;
  final String? description;

  MeritEntry.fromJson(Map<String, dynamic> json)
      : type = typeFromString(json["type"]!),
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
}

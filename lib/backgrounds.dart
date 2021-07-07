import 'package:get/get.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/vampite_character.dart';
import 'common_logic.dart';

class BackgroundsController extends GetxController {
  late final Database _database;
  var backgrounds = ComplexAbilityColumn('Backgrounds').obs;

  void fromJson(Map<String, dynamic> json, BackgroundDictionary bd) {
    // 1. Category headers. Re-read mostly for localization, might kill later
    // if (dictionary.name.isNotEmpty) {
    //   backgrounds.value.name.value = dictionary.name;
    // }

    _fillBackgroundList(json, bd);
  }

  void _fillBackgroundList(
      Map<String, dynamic> attributes, BackgroundDictionary bd) {
    print("Filling background?");
    for (var id in attributes.keys) {
      print("Adding $id from JSON");
      var entry = bd.backgrounds[id];
      if (attributes[id] != null && attributes[id] is Map<String, dynamic>) {
        ComplexAbility ca = ComplexAbility(
          id: entry?.databaseId,
          name: entry?.name ?? id,
          current: attributes[id]["current"] ?? 1,
          min: 0,
          max: 5,
          specialization: "",
          isIncremental: true, // Backgrounds are incremental
          hasSpecialization: false,
        );

        backgrounds.value.add(ca);
      }
    }
  }

  List<Map<String, dynamic>> save() {
    List<Map<String, dynamic>> shortAttributes = [];
    for (var attribute in backgrounds.value.values) {
      Map<String, dynamic> attr = Map();
      attr["name"] = attribute.name;
      attr["current"] = attribute.current;
      shortAttributes.add(attr);
    }
    return shortAttributes;
  }

  void fromDatabase(Database database) async {
    _database = database;

    var r = await _database.query('player_backgrounds',
        where: 'player_id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
    for (var response in r) {
      var entry = (await _database.query(
        'backgrounds',
        columns: ['name'],
        where: 'id = ?',
        whereArgs: [response['background_id'] as int],
      ))[0];

      backgrounds.value.add(ComplexAbility(
        id: Get.find<VampireCharacter>().characterId.value,
        name: entry['name'] as String,
        current: response['level'] as int,
        hasSpecialization: false,
      ));
    }
  }
}

class BackgroundDictionary extends Dictionary {
  BackgroundDictionary(String file) : super(file);

  Map<String, ComplexAbilityEntry> backgrounds = Map();

  String name = "Backgrounds";

  @override
  void load(Map<String, dynamic> json) {
    // 1. Get locale, not done at all

    // 2. Get attribute categories
    if (json["name"] != null) {
      name = json["name"];
    }

    // 4. Get backgrounds
    if (json["backgrounds"] != null &&
        json["backgrounds"] is Map<String, dynamic>) {
      Map<String, dynamic> entries = json["backgrounds"];

      for (var id in entries.keys) {
        if (entries[id] == null) {
          entries[id] = ComplexAbilityEntry(name: id);
        }
        backgrounds[id] = ComplexAbilityEntry.fromJson(entries[id]);
      }
    }
  }

  @override
  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();

    // CRUTCH until localization
    json["locale"] = "en-US";
    json["name"] = name;
    json["backgrounds"] = backgrounds;

    changed = false;

    return json;
  }

  @override
  Future<void> loadAllToDatabase(Database database) async {
    for (var textId in backgrounds.keys) {
      int id = await database.insert(
          'backgrounds', backgrounds[textId]!.toDatabaseMap(textId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (backgrounds[textId]!.levels.isNotEmpty) {
        for (var entry
            in backgrounds[textId]!.levelsToDatabase(id, 'background_id')!) {
          await database.insert('background_levels', entry,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'backgrounds.dart';
import 'disciplines.dart';
import 'merits_and_flaws.dart';
import 'rituals.dart';
import 'xp.dart';
import 'abilities.dart';
import 'attributes.dart';
import 'main_info.dart';
import 'virtues.dart';

/// Controller for the whole character. Handles saving and loading data from files, and, possibly, any other character-wide operations
class VampireCharacter extends GetxController {
  late String _characterFileName;
  late Database database;
  late bool installed;

  var characterId = 0.obs;

  Future<void> loadSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    installed = preferences.getBool('installed') ?? false;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["most_varied_variables"] = Get.find<MostVariedController>().save();
    json["virtues"] = Get.find<VirtuesController>().save();
    json["main_info"] = Get.find<MainInfoController>().save();
    json["attributes"] = Get.find<AttributesController>().toJson();
    json["abilities"] = Get.find<AbilitiesController>().save();
    json["merits"] = Get.find<MeritsAndFlawsController>().saveMerits();
    json["flaws"] = Get.find<MeritsAndFlawsController>().saveFlaws();
    json["disciplines"] = Get.find<DisciplineController>().save();
    json["rituals"] = Get.find<RitualController>().save();
    json["xp"] = Get.find<XpController>().save();
    return json;
  }

  Future<String> _loadAttributeList() async =>
      rootBundle.loadString('assets/json/default_attributes_en_US.json');

  Future<String> _loadAbilitiesList() async =>
      rootBundle.loadString('assets/json/default_abilities_en_US.json');

  Future<String> _loadBackgroundList() async =>
      rootBundle.loadString('assets/json/default_backgrounds_en_US.json');

  Future<String> _loadMeritsAndFlawsList() async =>
      rootBundle.loadString('assets/json/default_merits_and_flaws_en_US.json');

  Future<String> _loadDisciplineList() async =>
      rootBundle.loadString('assets/json/default_disciplines_en_US.json');

  Future<String> _loadRitualsList() async =>
      rootBundle.loadString('assets/json/default_rituals_en_US.json');

  Future<String> _loadCharacter() async =>
      rootBundle.loadString('assets/json/default_character_en_US.json');

  /// Loads a local JSON character file
  Future<void> load() async {
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      if (GetPlatform.isAndroid) {
        // Open the database and store the reference.
        database = await openDatabase(
            join(
              await getDatabasesPath(),
              'kindred_database.db',
            ),
            version: 1, onCreate: (database, version) async {
          // 1. Get assets/json/sql/tables.sql. It creates the tables
          String tableScript =
              await rootBundle.loadString('assets/sql/tables.sql');

          var scripts = tableScript.split(';');
          scripts.removeLast();
          for (var script in scripts) {
            await database.execute(script);
          }
          // 2. Load default_*.json into the tables
          // Attribute dictionary
          AttributeDictionary atrd =
              AttributeDictionary(await _loadAttributeList());
          await atrd.loadAllToDatabase(database);

          // Abilities dictionary
          AbilitiesDictionary abd =
              AbilitiesDictionary(await _loadAbilitiesList());
          await abd.loadAllToDatabase(database);

          // Backgrounds dictionary
          BackgroundDictionary backd =
              BackgroundDictionary(await _loadBackgroundList());
          await backd.loadAllToDatabase(database);

          // Merits and Flaws dictionary
          MeritsAndFlawsDictionary mfd =
              MeritsAndFlawsDictionary(await _loadMeritsAndFlawsList());
          await mfd.loadAllToDatabase(database);

          // Disciplines dictionary
          DisciplineDictionary dd =
              DisciplineDictionary(await _loadDisciplineList());
          await dd.loadAllToDatabase(database);

          // Rituals dictionary
          RitualDictionary rd = RitualDictionary(await _loadRitualsList());
          await rd.loadAllToDatabase(database);

          print("Loading default character");
          var characterFile = jsonDecode(await _loadCharacter());
          Get.put(MostVariedController());
          Get.find<MostVariedController>()
              .fromJson(characterFile['most_varied_variables']);

          Get.put(VirtuesController());
          Get.find<VirtuesController>().load(characterFile['virtues']);

          Get.put(MainInfoController());
          Get.find<MainInfoController>().load(characterFile['main_info']);

          Get.put(AttributesController());
          Get.find<AttributesController>().load(characterFile['attributes']);

          Get.put(AbilitiesController(database));
          await Get.find<AbilitiesController>()
              .fromJson(characterFile['abilities']);

          Get.put(BackgroundsController());
          Get.find<BackgroundsController>()
              .fromJson(characterFile['backgrounds'], backd);

          Get.put(MeritsAndFlawsController());
          Get.find<MeritsAndFlawsController>()
              .loadMerits(characterFile['merits']);
          Get.find<MeritsAndFlawsController>()
              .loadFlaws(characterFile['flaws']);

          Get.put(DisciplineController());
          Get.find<DisciplineController>().load(characterFile['disciplines']);

          Get.put(RitualController());
          Get.find<RitualController>().load(characterFile['rituals'], rd, dd);

          int id = await database.insert('characters', {
            'name': Get.find<MainInfoController>().characterName,
            'player_name': Get.find<MainInfoController>().playerName,
            'chronicle': Get.find<MainInfoController>().chronicle,
            'nature': Get.find<MainInfoController>().nature,
            'demeanor': Get.find<MainInfoController>().demeanor,
            'concept': Get.find<MainInfoController>().concept,
            'clan': Get.find<MainInfoController>().clan,
            'generation': Get.find<MainInfoController>().generation,
            'sire': Get.find<MainInfoController>().sire,
            'conscience': Get.find<VirtuesController>().conscience,
            'self_control': Get.find<VirtuesController>().selfControl,
            'courage': Get.find<VirtuesController>().courage,
            'additional_humanity': Get.find<VirtuesController>().humanity,
            'additional_willpower': Get.find<VirtuesController>().willpower,
            'blood_max': Get.find<MostVariedController>().bloodMax,
            'will': Get.find<MostVariedController>().will,
            'blood': Get.find<MostVariedController>().blood,
          });

          for (var attribute in Get.find<AttributesController>().attributes) {
            var response = await database.query('attributes',
                columns: ['id'],
                where: 'txt_id = ?',
                whereArgs: [attribute.txtId]);

            await database.insert('player_attributes', {
              'player_id': id,
              'attribute_id': response[0]['id'] as int,
              'current': attribute.current,
            });
          }

          print("Default database initialized");
          version = 0;
        }, onOpen: (database) async {
          print("Loading character data");

          var response =
              await database.query('characters', columns: ['id'], limit: 1);
          characterId.value = response[0]['id'] as int;

          Get.put(MostVariedController());
          Get.find<MostVariedController>().fromDatabase(database);
          Get.put(MainInfoController());
          Get.find<MainInfoController>().fromDatabase(database);
          Get.put(BackgroundsController());
          Get.find<BackgroundsController>().fromDatabase(database);
          Get.put(VirtuesController());
          Get.find<VirtuesController>().fromDatabase(database);
        });

        // else just use the defaults
      }
    } else {
      Get.back();
      // I haven't handled this platform yet. It may or may not support local file access
      throw ("This platform is not supported in file handling yet");
    }
  }

  /// Saves back a local JSON character file
  void save() async {
    Get.snackbar("Saving...", "Saving character info");
    if (GetPlatform.isAndroid) {
      getApplicationDocumentsDirectory().then((value) {
        File characterFile = File(value.path + '/' + _characterFileName);
        Map<String, dynamic> json = toJson();
        print("Saving character to file ${characterFile.path}");
        for (var entry in json.entries) {
          print("${entry.key} : '${entry.value}'");
        }
        characterFile.writeAsStringSync(jsonEncode(json));
      });
    } else if (GetPlatform.isWeb) {
      throw ("Web can't store files");
    } else {
      // I haven't handled this platform yet. It may or may not support local file access
      throw ("This platform is not supported in file handling yet");
    }
    Get.back();
  }

  Future<void> init() async {
    return load();
  }

  void onClose() {
    save();
    super.onClose();
  }
}

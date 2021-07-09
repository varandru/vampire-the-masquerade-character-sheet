import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'abilities.dart';
import 'attributes.dart';
import 'backgrounds.dart';
import 'disciplines.dart';
import 'main_info.dart';
import 'merits_and_flaws.dart';
import 'rituals.dart';
import 'virtues.dart';

class DatabaseController extends GetxController {
  late Database database;
  var characterId = 0.obs;

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

  Future<void> init() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'kindred_database.db'));

    database = await openDatabase(
        join(await getDatabasesPath(), 'kindred_database.db'),
        version: 1, onCreate: (database, version) async {
      // 1. Get assets/json/sql/tables.sql. It creates the tables
      String tableScript = await rootBundle.loadString('assets/sql/tables.sql');

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
      AbilitiesDictionary abd = AbilitiesDictionary(await _loadAbilitiesList());
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
      Get.find<MeritsAndFlawsController>().loadMerits(characterFile['merits']);
      Get.find<MeritsAndFlawsController>().loadFlaws(characterFile['flaws']);

      Get.put(DisciplineController());
      Get.find<DisciplineController>().load(characterFile['disciplines']);

      Get.put(RitualController());
      Get.find<RitualController>().load(characterFile['rituals'], rd, dd);

      await database.delete('characters');

      int id = await database.insert(
          'characters',
          {
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
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      for (var attribute in Get.find<AttributesController>().attributes) {
        var response = await database.query('attributes',
            columns: ['id'], where: 'txt_id = ?', whereArgs: [attribute.txtId]);

        await database.insert(
            'player_attributes',
            {
              'player_id': id,
              'attribute_id': response[0]['id'] as int,
              'current': attribute.current,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      for (var attribute
          in Get.find<BackgroundsController>().backgrounds.value.values) {
        var response = await database.query('backgrounds',
            columns: ['id'], where: 'txt_id = ?', whereArgs: [attribute.txtId]);

        await database.insert(
            'player_backgrounds',
            {
              'player_id': id,
              'background_id': response[0]['id'] as int,
              'current': attribute.current,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      print("Default database initialized");
    }, onOpen: (database) async {
      print("Loading character data");

      var response =
          await database.query('characters', columns: ['id'], limit: 1);
      characterId.value = response[0]['id'] as int;

      Get.put(MostVariedController());
      Get.find<MostVariedController>().fromDatabase(database);
      Get.put(MainInfoController());
      Get.find<MainInfoController>().fromDatabase(database);
      Get.put(VirtuesController());
      Get.find<VirtuesController>().fromDatabase(database);
      Get.put(BackgroundsController());
      Get.find<BackgroundsController>().fromDatabase(database);
    });
  }

  // Future<String> getConscience
}

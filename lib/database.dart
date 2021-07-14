import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';

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

      Get.put(AbilitiesController());
      Get.find<AbilitiesController>().fromJson(characterFile['abilities']);

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
      Get.put(AttributesController());
      Get.find<AttributesController>().fromDatabase(database);
      Get.put(AbilitiesController());
      Get.find<AbilitiesController>().fromDatabase(database);
      Get.put(DisciplineController());
      Get.find<DisciplineController>().fromDatabase(database);
      Get.put(RitualController());
      Get.find<RitualController>().fromDatabase(database);
    });
  }

  /// This is basically backgrounds, lol
  Future<int> updateComplexAbilityNoFilter(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      database
          .query(
            description.tableName,
            where: 'id = ?',
            whereArgs: [entry.databaseId],
          )
          .then((value) => Get.find<DatabaseController>().database.insert(
                description.tableName,
                {
                  'id': entry.databaseId,
                  'name': entry.name,
                  'description': entry.description ??
                      (value.length > 0 ? value[0]['description'] : null),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              ))

          /// Current, possibly new id
          .then((value) => Get.find<DatabaseController>().database.insert(
                description.playerLinkTable,
                {
                  'player_id': Get.find<DatabaseController>().characterId.value,
                  description.fkName: value,
                  'current': ability.current,
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              ));

  Future<int> updateComplexAbilityWithFilter(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      database
          .query(
            description.tableName,
            columns: ['description', 'txt_id'],
            where: 'id = ?',
            whereArgs: [entry.databaseId],
          )
          .then((value) => Get.find<DatabaseController>().database.insert(
                description.tableName,
                {
                  'id': entry.databaseId,
                  'txt_id':
                      (value.length > 0 ? value[0]['txt_id'] : ability.txtId),
                  'name': entry.name,
                  'type': description.filter,
                  'description': entry.description ??
                      (value.length > 0 ? value[0]['description'] : null),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              ))

          /// Current, possibly new id
          .then((value) => Get.find<DatabaseController>().database.insert(
                description.playerLinkTable,
                {
                  'player_id': Get.find<DatabaseController>().characterId.value,
                  description.fkName: value,
                  'current': ability.current,
                  'specialization': ability.specialization.isNotEmpty
                      ? ability.specialization
                      : null
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              ));

  Future<int> insertComplexAbilityWithFilter(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      database
          .insert(
              description.tableName,
              {
                'id': entry.databaseId,
                'txt_id': ability.txtId,
                'name': entry.name,
                'description': entry.description,
                'type': description.filter,
              },
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) => database.insert(description.playerLinkTable, {
                'player_id': characterId.value,
                description.fkName: value,
                'current': ability.current,
                'specialization': ability.specialization,
              }));

  Future<void> insertOrUpdateRitual(Ritual ritual) async {
    database.transaction((txn) async {
      int? ritualId;

      /// 1. Let's handle school id
      /// 1.1 If it isn't in ritual itself, try from DB
      if (ritual.schoolId == null && ritual.school.isNotEmpty) {
        ritual.schoolId = await database
            .query(
              'ritual_schools',
              columns: ['id'],
              where: 'name = ?',
              whereArgs: [ritual.school],
            )
            .then((value) => value.length > 0 ? value[0]['id'] as int : null);
      }

      /// 2. Let's handle entry.
      /// Does it even have a database id?
      if (ritual.dbId != null) {
        /// Then is there a corresponding ritual?
        var response = await txn.query('rituals', where: 'id = ?');
        if (response.length > 0) {
          /// Fine, update it. Inserting will break foreign keys
          Map<String, Object> arguments = {
            'level': ritual.level,
            'name': ritual.name,
            'system': ritual.system,
          };
          if (ritual.id != null) arguments['txt_id'] = ritual.id!;
          if (ritual.description != null)
            arguments['description'] = ritual.description!;
          if (ritual.schoolId != null)
            arguments['discipline_id'] = ritual.schoolId!;
          await txn.update('rituals', arguments,
              where: 'id = ?', whereArgs: [ritual.dbId!]);
          ritualId = ritual.dbId;
        } else {
          /// There isn't a corresponding ritual. Let's add it.
          ritualId = await database.insert('rituals', {
            'level': ritual.level,
            'name': ritual.name,
            'system': ritual.system,
            'txt_id': ritual.id,
            'description': ritual.description!,
            'discipline_id': ritual.schoolId!
          });
        }
      } else {
        /// There is no database ritual id. Let's just add a new one,
        /// and if there are duplicates, look here
        ritualId = await database.insert('rituals', {
          'level': ritual.level,
          'name': ritual.name,
          'system': ritual.system,
          'txt_id': ritual.id,
          'description': ritual.description!,
          'discipline_id': ritual.schoolId!
        });
      }
      return database.insert('player_rituals',
          {'player_id': characterId.value, 'ritual_id': ritualId},
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}

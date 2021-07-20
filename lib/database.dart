import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';
import 'package:vampire_the_masquerade_character_sheet/xp.dart';

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
      Get.find<AttributesController>().load(characterFile['attributes'], atrd);

      Get.put(AbilitiesController());
      Get.find<AbilitiesController>().fromJson(characterFile['abilities'], abd);

      Get.put(BackgroundsController());
      Get.find<BackgroundsController>()
          .fromJson(characterFile['backgrounds'], backd);

      Get.put(MeritsAndFlawsController());
      Get.find<MeritsAndFlawsController>()
          .loadMerits(characterFile['merits'], mfd);
      Get.find<MeritsAndFlawsController>()
          .loadFlaws(characterFile['flaws'], mfd);

      Get.put(DisciplineController());
      Get.find<DisciplineController>().load(characterFile['disciplines'], dd);

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
            'humanity': Get.find<VirtuesController>().humanity,
            'willpower': Get.find<VirtuesController>().willpower,
            'blood_max': Get.find<MostVariedController>().bloodMax,
            'will': Get.find<MostVariedController>().will,
            'blood': Get.find<MostVariedController>().blood,
          },
          conflictAlgorithm: ConflictAlgorithm.rollback);

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
            conflictAlgorithm: ConflictAlgorithm.rollback);
      }

      for (var ability in Get.find<AbilitiesController>().abilities) {
        var response = await database.query('abilities',
            columns: ['id'], where: 'txt_id = ?', whereArgs: [ability.txtId]);
        print('Adding ability ${ability.txtId}');

        await database.insert(
            'player_abilities',
            {
              'player_id': id,
              'ability_id': response[0]['id'] as int,
              'current': ability.current,
            },
            conflictAlgorithm: ConflictAlgorithm.rollback);
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
            conflictAlgorithm: ConflictAlgorithm.rollback);
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
      Get.put(MeritsAndFlawsController());
      Get.find<MeritsAndFlawsController>().fromDatabase(database);
      Get.put(XpController());
      Get.find<XpController>().fromDatabase(database);
    });
  }

  Future<int> addDiscipline(Discipline discipline) => database
      .insert(
          'disciplines',
          {
            'txt_id': discipline.txtId,
            'name': discipline.name,
            'description': discipline.description,
            'system': discipline.system,
            'maximum': discipline.max,
          },
          conflictAlgorithm: ConflictAlgorithm.rollback)
      .then((value) => database.insert(
          'player_disciplines',
          {
            'player_id': characterId.value,
            'discipline_id': value,
            'level': discipline.level,
          },
          conflictAlgorithm: ConflictAlgorithm.replace));

  Future<int> addOrUpdateComplexAbility(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      description.filter == null
          ? _addOrUpdateComplexAbilityWithoutFilter(ability, entry, description)
          : _addOrUpdateComplexAbilityWithFilter(ability, entry, description);

  Future<int> _addOrUpdateComplexAbilityWithFilter(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      database.transaction((txn) => (ability.id == null)
          ? txn
              .insert(
                  description.tableName,
                  {
                    'id': entry.databaseId,
                    'txt_id': ability.txtId,
                    'name': entry.name,
                    'description': entry.description,
                    'type': description.filter,
                  },
                  conflictAlgorithm: ConflictAlgorithm.rollback)
              .then(
                (index) => txn.insert(
                  description.playerLinkTable,
                  {
                    'player_id': characterId.value,
                    description.fkName: index,
                    'current': ability.current,
                    'specialization': ability.specialization,
                  },
                ).then((value) => index),
              )
          : txn.query(description.tableName, where: 'id = ?', whereArgs: [
              ability.id
            ]).then((value) => value.length != 0
              ? ((value[0]['txt_id'] == null)
                      ? txn
                          .update(
                              description.tableName,
                              {
                                'txt_id': ability.txtId ??
                                    value[0]['txt_id'] as String?,
                                'name': entry.name,
                                'description': entry.description ??
                                    value[0]['txt_id'] as String?,
                              },
                              where: 'id = ?',
                              whereArgs: [ability.id])
                          .then((value) => ability.id!)
                      : txn
                          .update(
                              description.tableName,
                              {
                                'name': entry.name,
                                'description': entry.description ??
                                    value[0]['description'] as String?,
                              },
                              where: 'id = ?',
                              whereArgs: [ability.id])
                          .then((value) => txn.insert(
                                description.playerLinkTable,
                                {
                                  'player_id': characterId.value,
                                  description.fkName: ability.id,
                                  'current': ability.current,
                                  'specialization': ability.specialization,
                                },
                                conflictAlgorithm: ConflictAlgorithm.replace,
                              )))
                  .then((value) => ability.id!)
              : txn
                  .insert(
                      description.tableName,
                      {
                        'id': entry.databaseId,
                        'txt_id': ability.txtId,
                        'name': entry.name,
                        'description': entry.description,
                        'type': description.filter,
                      },
                      conflictAlgorithm: ConflictAlgorithm.rollback)
                  .then((value) => txn
                      .insert(
                        description.playerLinkTable,
                        {
                          'player_id': characterId.value,
                          description.fkName: ability.id,
                          'current': ability.current,
                          'specialization': ability.specialization,
                        },
                        conflictAlgorithm: ConflictAlgorithm.replace,
                      )
                      .then((value) => ability.id!))));

  /// It's only backgrounds, but it doesn't update specializations as well
  Future<int> _addOrUpdateComplexAbilityWithoutFilter(
          ComplexAbility ability,
          ComplexAbilityEntry entry,
          ComplexAbilityEntryDatabaseDescription description) =>
      database.transaction((txn) => (ability.id == 0)
          ? txn
              .insert(
                  description.tableName,
                  {
                    'id': entry.databaseId,
                    'txt_id': ability.txtId,
                    'name': entry.name,
                    'description': entry.description,
                  },
                  conflictAlgorithm: ConflictAlgorithm.rollback)
              .then(
                (value) => txn.insert(
                  description.playerLinkTable,
                  {
                    'player_id': characterId.value,
                    description.fkName: value,
                    'current': ability.current,
                  },
                ),
              )
          : txn.query(description.tableName, where: 'id = ?', whereArgs: [
              ability.id
            ]).then((value) => value.length != 0
              ? ((value[0]['txt_id'] == null)
                  ? txn.update(
                      description.tableName,
                      {
                        'txt_id':
                            ability.txtId ?? value[0]['txt_id'] as String?,
                        'name': entry.name,
                        'description':
                            entry.description ?? value[0]['txt_id'] as String?,
                      },
                      where: 'id = ?',
                      whereArgs: [ability.id])
                  : txn
                      .update(
                          description.tableName,
                          {
                            'name': entry.name,
                            'description': entry.description ??
                                value[0]['description'] as String?,
                          },
                          where: 'id = ?',
                          whereArgs: [ability.id])
                      .then((value) => txn.insert(
                            description.playerLinkTable,
                            {
                              'player_id': characterId.value,
                              description.fkName: ability.id,
                              'current': ability.current,
                            },
                            conflictAlgorithm: ConflictAlgorithm.replace,
                          )))
              : txn
                  .insert(
                      description.tableName,
                      {
                        'id': entry.databaseId,
                        'txt_id': ability.txtId,
                        'name': entry.name,
                      },
                      conflictAlgorithm: ConflictAlgorithm.rollback)
                  .then((value) => txn.insert(
                        description.playerLinkTable,
                        {
                          'player_id': characterId.value,
                          description.fkName: ability.id,
                          'current': ability.current,
                        },
                        conflictAlgorithm: ConflictAlgorithm.replace,
                      ))));

  Future<void> addOrUpdateRitual(Ritual ritual) async {
    database.transaction((txn) async {
      int? ritualId;

      /// 1. Let's handle school id
      /// 1.1 If it isn't in ritual itself, try from DB
      if (ritual.schoolId == null && ritual.school.isNotEmpty) {
        ritual.schoolId = await txn
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
          ritualId = await txn.insert('rituals', {
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
        ritualId = await txn.insert('rituals', {
          'level': ritual.level,
          'name': ritual.name,
          'system': ritual.system,
          'txt_id': ritual.id,
          'description': ritual.description!,
          'discipline_id': ritual.schoolId!
        });
      }
      return txn.insert('player_rituals',
          {'player_id': characterId.value, 'ritual_id': ritualId},
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  Future<int> _addOrUpdateMeritOrFlaw(Merit merit, String table) async {
    if (merit.id != 0) {
      await database.update(
        '$table' 's',
        {
          'name': merit.name,
          'type': intFromType(merit.type),
          'description': merit.description
        },
      );
    } else {
      merit.id = await database.insert(
        '$table' 's',
        {
          'name': merit.name,
          'txt_id': merit.txtId,
          'type': intFromType(merit.type),
          'description': merit.description
        },
      );
      await database.insert(
          '$table' '_costs',
          {
            '$table' '_id': merit.id,
            'cost': merit.cost,
          },
          conflictAlgorithm: ConflictAlgorithm.abort);
    }
    return database.insert(
        'player_$table' 's',
        {
          'player_id': characterId.value,
          '$table' '_id': merit.id,
          'cost': merit.cost,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addOrUpdateMerit(Merit merit) =>
      _addOrUpdateMeritOrFlaw(merit, 'merit');

  Future<int> addOrUpdateFlaw(Merit flaw) =>
      _addOrUpdateMeritOrFlaw(flaw, 'flaw');

  Future<int> deleteMeritOrFlaw(Merit merit, bool isMerit) =>
      database.delete(isMerit ? 'merits' : 'flaws',
          where: 'player_id = ? and ${isMerit ? 'merit' : 'flaw'}_id = ?',
          whereArgs: [characterId.value, merit.id]);

  Future<void> addXpEntry(XpEntry entry) async {
    if (entry is XpEntryGained) {
      database.insert('player_xp', {
        'player_id': characterId.value,
        'cost': entry.gained,
        'description': entry.description
      });
    } else if (entry is XpEntryNewAbility) {
      database.insert('player_xp', {
        'player_id': characterId.value,
        'description': entry.description,
        'cost': entry.cost,
        'name': entry.name
      });
    } else if (entry is XpEntryUpgradedAbility) {
      database.insert('player_xp', {
        'player_id': characterId.value,
        'description': entry.description,
        'cost': entry.cost,
        'name': entry.name,
        'old_level': entry.oldLevel,
        'new_level': entry.newLevel,
      });
    }
  }
}

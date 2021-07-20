import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

enum DamageType { None, Bludgeoning, Lethal, Aggravated }

int intFromDamageType(DamageType type) {
  switch (type) {
    case DamageType.None:
      return 0;
    case DamageType.Bludgeoning:
    case DamageType.Lethal:
      return 1;
    case DamageType.Aggravated:
      return 2;
  }
}

DamageType damageTypeFromInt(int type) {
  switch (type) {
    case 0:
      return DamageType.None;
    case 1:
      return DamageType.Lethal;
    case 2:
      return DamageType.Aggravated;
    default:
      return DamageType.None;
  }
}

class DamageDot {
  DamageDot({required this.type, required this.name, required this.id});
  DamageType type;
  String name;
  int id;
}

class DamageController extends GetxController {
  RxMap<int, DamageDot> damage = RxMap();

  var lethalDamage = 0.obs;
  var aggravatedDamage = 0.obs;

  void switchType(DamageType oldType, DamageType newType) async {
    int lethalChange = 0;
    int aggravatedChange = 0;

    switch (oldType) {
      case DamageType.None:
        break;
      case DamageType.Bludgeoning:
      case DamageType.Lethal:
        lethalChange--;
        break;
      case DamageType.Aggravated:
        aggravatedChange--;
        break;
    }

    switch (newType) {
      case DamageType.None:
        break;
      case DamageType.Bludgeoning:
      case DamageType.Lethal:
        lethalChange++;
        break;
      case DamageType.Aggravated:
        aggravatedChange++;
        break;
    }

    lethalDamage.value += lethalChange;
    aggravatedDamage.value += aggravatedChange;

    for (int i = 0; i < aggravatedDamage.value && i < damage.length; i++) {
      damage.update(i, (value) {
        value.type = DamageType.Aggravated;
        return value;
      });
      await Get.find<DatabaseController>().database.update(
          'player_damage', {'status': intFromDamageType(DamageType.Aggravated)},
          where: 'player_id = ? and level = ?',
          whereArgs: [Get.find<DatabaseController>().characterId.value, i]);
    }
    for (int i = aggravatedDamage.value;
        i < lethalDamage.value + aggravatedDamage.value && i < damage.length;
        i++) {
      damage.update(i, (value) {
        value.type = DamageType.Lethal;
        return value;
      });
      await Get.find<DatabaseController>().database.update(
          'player_damage', {'status': intFromDamageType(DamageType.Lethal)},
          where: 'player_id = ? and level = ?',
          whereArgs: [Get.find<DatabaseController>().characterId.value, i]);
    }
    for (int i = lethalDamage.value + aggravatedDamage.value;
        i < damage.length;
        i++) {
      damage.update(i, (value) {
        value.type = DamageType.None;
        return value;
      });
      await Get.find<DatabaseController>().database.update(
          'player_damage', {'status': intFromDamageType(DamageType.None)},
          where: 'player_id = ? and level = ?',
          whereArgs: [Get.find<DatabaseController>().characterId.value, i]);
    }
  }

  Future<void> fromDatabase(Database database) async {
    return database.rawQuery(
        'select pd.id, hl.name, pd.status, pd.level, hl.penalty '
        'from player_damage pd inner join health_levels hl '
        'on pd.level = hl.level where pd.player_id = ? '
        'order by pd.level',
        [Get.find<DatabaseController>().characterId.value]).then((value) async {
      if (value.length != 7) {
        await database.delete('player_damage',
            where: 'player_id = ?',
            whereArgs: [
              Get.find<DatabaseController>().characterId.value
            ]).then((value) => fillDefaultHealthLevelsForPlayer(
                database, Get.find<DatabaseController>().characterId.value)
            .then((value) => fromDatabase(database)));
      } else {
        for (var item in value) {
          damage[item['level'] as int] = DamageDot(
              type: damageTypeFromInt(item['status'] as int),
              name: item['name'] as String,
              id: item['id'] as int);
        }
      }
    });
  }

  Future<void> fillDefaultHealthLevelsForPlayer(
      Database database, int playerId) async {
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 1},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 2},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 3},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 4},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 5},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'player_damage', {'player_id': playerId, 'status': 0, 'level': 6},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> fillDefaultHealthLevels(Database database) async {
    await database.insert(
        'health_levels', {'level': 0, 'name': 'Bruised', 'penalty': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 1, 'name': 'Hurt', 'penalty': -1},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 2, 'name': 'Injured', 'penalty': -1},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 3, 'name': 'Wounded', 'penalty': -2},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 4, 'name': 'Mauled', 'penalty': -2},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 5, 'name': 'Crippled', 'penalty': -5},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert(
        'health_levels', {'level': 6, 'name': 'Incapacitated', 'penalty': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

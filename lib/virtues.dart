import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'vampite_character.dart';

class VirtuesController extends GetxController {
  late final Database _database;

  var _conscience = 1.obs;
  var _selfControl = 1.obs;
  var _courage = 5.obs;

  var _additionalHumanity = 0.obs;
  var _additionalWillpower = 0.obs;

  int get conscience => _conscience.value;
  int get selfControl => _selfControl.value;
  int get courage => _courage.value;

  int get humanity => _additionalHumanity.value;
  int get willpower => _additionalWillpower.value;

  // int get humanity =>
  //     _conscience.value + _selfControl.value + _additionalHumanity.value;
  // int get willpower => _courage.value + _additionalWillpower.value;

  set conscience(int conscience) {
    _conscience.value = conscience;
    _database
        .update('characters', {'conscience': conscience},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update conscience, value = $value'));
  }

  set selfControl(int selfControl) {
    _selfControl.value = selfControl;
    _database
        .update('characters', {'self_control': selfControl},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update selfControl, value = $value'));
  }

  set courage(int courage) {
    _courage.value = courage;
    _database
        .update('characters', {'courage': courage},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update courage, value = $value'));
  }

  set humanity(int additionalHumanity) {
    _additionalHumanity.value = additionalHumanity;
    _database
        .update('characters', {'additional_humanity': additionalHumanity},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update additionalHumanity, value = $value'));
  }

  set willpower(int additionalWillpower) {
    _additionalWillpower.value = additionalWillpower;
    _database
        .update('characters', {'additional_willpower': additionalWillpower},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update additionalWillpower, value = $value'));
  }

  void load(Map<String, dynamic> json) {
    _conscience.value = json["consience"] ?? 0;
    _selfControl.value = json["self_control"] ?? 0;
    _courage.value = json["courage"] ?? 0;

    _additionalHumanity.value = json["additional_humanity"] ?? 0;
    _additionalWillpower.value = json["additional_willpower"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["consience"] = _conscience.value;
    json["self_control"] = _selfControl.value;
    json["courage"] = _courage.value;

    json["additional_humanity"] = _additionalHumanity.value;
    json["additional_willpower"] = _additionalWillpower.value;
    return json;
  }

  Future<void> fromDatabase(Database database) async {
    _database = database;
    var response = await _database.query('characters',
        columns: [
          'conscience',
          'self_control',
          'courage',
          'additional_humanity',
          'additional_willpower'
        ],
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);

    if (response.length == 0) throw ('No character in database');
    _conscience.value = response[0]['conscience'] as int;
    _selfControl.value = response[0]['self_control'] as int;
    _courage.value = response[0]['courage'] as int;

    _additionalHumanity.value = response[0]['additional_humanity'] as int;
    _additionalWillpower.value = response[0]['additional_willpower'] as int;
  }
}

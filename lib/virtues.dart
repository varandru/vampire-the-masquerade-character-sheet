import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class VirtuesController extends GetxController {
  var _conscience = 1.obs;
  var _selfControl = 1.obs;
  var _courage = 5.obs;

  var _humanity = 0.obs;
  var _willpower = 0.obs;

  int get conscience => _conscience.value;
  int get selfControl => _selfControl.value;
  int get courage => _courage.value;

  int get humanity => _humanity.value;
  int get willpower => _willpower.value;

  set conscience(int conscience) {
    _conscience.value = conscience;
    Get.find<DatabaseController>()
        .database
        .update('characters', {'conscience': conscience},
            where: 'id = ?',
            whereArgs: [Get.find<DatabaseController>().characterId.value])
        .then((value) => print('Update conscience, value = $value'));
  }

  set selfControl(int selfControl) {
    _selfControl.value = selfControl;
    Get.find<DatabaseController>()
        .database
        .update('characters', {'self_control': selfControl},
            where: 'id = ?',
            whereArgs: [Get.find<DatabaseController>().characterId.value])
        .then((value) => print('Update selfControl, value = $value'));
  }

  set courage(int courage) {
    _courage.value = courage;
    Get.find<DatabaseController>()
        .database
        .update('characters', {'courage': courage},
            where: 'id = ?',
            whereArgs: [Get.find<DatabaseController>().characterId.value])
        .then((value) => print('Update courage, value = $value'));
  }

  set humanity(int humanity) {
    _humanity.value = humanity;
    Get.find<DatabaseController>()
        .database
        .update('characters', {'humanity': humanity},
            where: 'id = ?',
            whereArgs: [Get.find<DatabaseController>().characterId.value])
        .then((value) => print('Update humanity, value = $value'));
  }

  set willpower(int willpower) {
    _willpower.value = willpower;
    Get.find<DatabaseController>()
        .database
        .update('characters', {'willpower': willpower},
            where: 'id = ?',
            whereArgs: [Get.find<DatabaseController>().characterId.value])
        .then((value) => print('Update willpower, value = $value'));
  }

  void load(Map<String, dynamic> json) {
    _conscience.value = json["consience"] ?? 0;
    _selfControl.value = json["self_control"] ?? 0;
    _courage.value = json["courage"] ?? 0;

    _humanity.value = json["humanity"] ?? 0;
    _willpower.value = json["willpower"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["consience"] = _conscience.value;
    json["self_control"] = _selfControl.value;
    json["courage"] = _courage.value;

    json["humanity"] = _humanity.value;
    json["willpower"] = _willpower.value;
    return json;
  }

  Future<void> fromDatabase(Database database) async {
    var response = await database.query('characters',
        columns: [
          'conscience',
          'self_control',
          'courage',
          'humanity',
          'willpower'
        ],
        where: 'id = ?',
        whereArgs: [Get.find<DatabaseController>().characterId.value]);

    if (response.length == 0) throw ('No character in database');
    _conscience.value = response[0]['conscience'] as int;
    _selfControl.value = response[0]['self_control'] as int;
    _courage.value = response[0]['courage'] as int;

    _humanity.value = response[0]['humanity'] as int;
    _willpower.value = response[0]['willpower'] as int;
  }
}

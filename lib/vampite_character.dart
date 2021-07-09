import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

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
  // late Database database;
  late bool installed;

  // var characterId = 0.obs;

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

  /// Loads a local JSON character file
  Future<void> load() async {
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      if (GetPlatform.isAndroid) {
        // Open the database and store the reference.
        DatabaseController dc = Get.put(DatabaseController());
        await dc.init();
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

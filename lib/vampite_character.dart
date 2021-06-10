import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abilities.dart';
import 'attributes.dart';
import 'main_info.dart';

/// Controller for the whole character. Handles saving and loading data from files, and, possibly, any other character-wide operations
class VampireCharacter extends GetxController {
  // Comments mean: can save/can load. Not ++ means I'm not done
  late MostVariedController mostVariedController; // ++
  late VirtuesController virtuesController; // ++
  late MainInfo mainInfo; // ++
  late AttributesController attributesController; // -+
  late AbilitiesController abilitiesController; // --

  late String _characterFileName;
  late bool installed;

  Future<void> loadSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    installed = preferences.getBool('installed') ?? false;
  }

  void initialize() {
    print("Creating controllers!");
    mostVariedController = Get.put(MostVariedController());
    virtuesController = Get.put(VirtuesController());
    mainInfo = Get.put(MainInfo());
    attributesController = Get.put(AttributesController());
    abilitiesController = Get.put(AbilitiesController());
  }

  void _loadToControllers(Map<String, dynamic> json) {
    mostVariedController.load(json["most_varied_variables"]);
    virtuesController.load(json["virtues"]);
    mainInfo.load(json["main_info"]);
  }

  Map<String, dynamic> _saveFromControllers() {
    Map<String, dynamic> json = Map();
    json["most_varied_variables"] = mostVariedController.save();
    json["virtues"] = virtuesController.save();
    json["main_info"] = mainInfo.save();
    json["attributes"] = attributesController.save();
    return json;
  }

  Future<String> _loadAttributeList() async {
    var direcrory = await getApplicationDocumentsDirectory();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final attributeListFile = preferences.getString('attribute_dictionary') ??
        'default_attributes_en_US.json';
    File dictionaryFile = File(direcrory.path + '/' + attributeListFile);

    if (await dictionaryFile.exists()) {
      return dictionaryFile.readAsString();
    } else {
      throw ("Attribute dictionary does not exist");
    }
  }

  /// Loads a local JSON character file
  Future<void> load() async {
    Get.snackbar("Loading", "Loading character information");
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      if (GetPlatform.isAndroid) {
        var direcrory = await getApplicationDocumentsDirectory();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String characterFileName =
            preferences.getString('character_file') ?? "character.json";
        File characterFile = File(direcrory.path + '/' + characterFileName);

        if (characterFile.existsSync()) {
          // Attribute dictionary
          AttributeDictionary ad = AttributeDictionary();
          _loadAttributeList().then((value) {
            ad.load(jsonDecode(value));
            print(characterFile.readAsStringSync());
            Map<String, dynamic> json =
                jsonDecode(characterFile.readAsStringSync());
            _loadToControllers(json);
            if (json["attributes"] != null)
              attributesController.load(json["attributes"], ad);
          });
        }
        // else just use the defaults

      } else if (GetPlatform.isWeb) {
        // Web can't really store local files. Being in the, y'know, Web
        // But I use Chrome for debugging, so I kinda need it to not throw
        print("You are launching in Web. File operations are not available");
        attributesController.initializeFromConstants();
        abilitiesController.initializeFromConstants();
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
        Map<String, dynamic> json = _saveFromControllers();
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

  Future<void> install() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var directory = await getApplicationDocumentsDirectory();

    String attributeString =
        await rootBundle.loadString('assets/default_attributes_en_US.json');
    File attributeFile = File(directory.path +
        '/' +
        (preferences.getString('attribute_dictionary') ??
            'default_attributes_en_US.json'));

    attributeFile.writeAsStringSync(attributeString);

    await preferences.setBool('installed', true);
    print("Installation Done!");
  }

  Future<void> init() async {
    await loadSharedPreferences();
    if (!installed) {
      await install();
    }
    initialize();
    return load();
  }

  void onClose() {
    save();
    super.onClose();
  }
}

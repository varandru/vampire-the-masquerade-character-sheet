import 'dart:convert';
import 'dart:io' as io;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'attributes.dart';
import 'main_info.dart';

/// Controller for the whole character. Handles saving and loading data from files, and, possibly, any other character-wide operations
class VampireCharacter extends GetxController {
  late MainInfo mainInfo;
  late AttributesController attributesController;
  late MostVariedController mostVariedController;
  late VirtuesController virtuesController;

  final String _characterFileName = "character.json";

  void initialize() {
    mostVariedController = Get.put(MostVariedController());
    virtuesController = Get.put(VirtuesController());
    mainInfo = Get.put(MainInfo());
    attributesController = Get.put(AttributesController());
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
    return json;
  }

  /// Loads a local JSON character file
  void load() async {
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      if (GetPlatform.isAndroid) {
        getApplicationDocumentsDirectory().then((value) {
          io.File file = io.File(value.path + '/' + _characterFileName);
          if (file.existsSync()) {
            Map<String, dynamic> json = jsonDecode(file.readAsStringSync());
            _loadToControllers(json);
          }
          // else just use the defaults
        });
      } else if (GetPlatform.isWeb) {
        // Get Web path to file
      }
    } else {
      // I haven't handled this platform yet. It may or may not support local file access
      throw ("This platform is not supported in file handling yet");
    }
  }

  /// Saves back a local JSON character file
  void save() async {
    if (GetPlatform.isAndroid) {
      getApplicationDocumentsDirectory().then((value) {
        io.File file = io.File(value.path + '/' + _characterFileName);
        Map<String, dynamic> json = _saveFromControllers();

        //! Debug
        for (var entry in json.values) {
          if (entry.runtimeType == Map) {
            for (var field in entry.values) {
              print("   $field");
            }
          } else {
            print("$entry");
          }
        }

        String encoded = jsonEncode(json);

        //! Debug
        print("Encoded json: $encoded");

        file.writeAsStringSync(encoded);
      });
    } else if (GetPlatform.isWeb) {
      throw ("Web can't store files. I may have ");
    } else {
      // I haven't handled this platform yet. It may or may not support local file access
      throw ("This platform is not supported in file handling yet");
    }
  }
}

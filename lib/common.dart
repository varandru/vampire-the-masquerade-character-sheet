import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vampire_the_masquerade_character_sheet/main_info_logic.dart';
import 'dart:io';

import 'abilities.dart';
import 'advanatages.dart';
import 'merits_and_flaws.dart';
import 'disciplines.dart';
import 'drawer_menu.dart';
import 'main_info.dart';
import 'attributes_widget.dart';

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    Get.put(MainInfo());
    Get.put(MostVariedController());
    Get.put(VirtuesController());
    return GetMaterialApp(
      home: MenuScaffold(
        name: "Primary Information",
        body: ListView(
          children: [
            CommonCharacterInfoWidget(),
            AdvantagesWidget(),
          ],
          shrinkWrap: true,
          primary: true,
        ),
        selectedItem: SelectedMenuItem.PrimaryInfo,
      ),
    );
  }
}

// // Abilities Menu
// final abilitiesScaffold = MenuScaffold(
//   name: "Abilities",
//   body: ListView(
//     children: [
//       AttributesSectionWidget(),
//       AbilitiesSectionWidget(),
//     ],
//     shrinkWrap: true,
//     primary: true,
//   ),
//   item: SelectedMenuItem.Abilities,
// );

// // Disciplines Menu
// final disciplinesScaffold = MenuScaffold(
//   name: "Disciplines",
//   body: ListView(
//     children: [
//       DisciplinesSectionWidget(),
//     ],
//   ),
//   item: SelectedMenuItem.Disciplines,
// );

// // Disciplines Menu
// final meritsFlawsScaffold = MenuScaffold(
//   name: "Merits & Flaws",
//   body: MeritsAndFlawsSectionWidget(),
//   item: SelectedMenuItem.Disciplines,
// );

class MenuScaffold extends StatelessWidget {
  MenuScaffold(
      {required String name,
      required Widget body,
      required SelectedMenuItem selectedItem})
      : _name = name,
        _body = body,
        _item = selectedItem;

  final String _name;
  final Widget _body;
  final SelectedMenuItem _item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        actions: [
          IconButton(
            onPressed: () {
              getApplicationDocumentsDirectory().then((value) {
                File file = File(value.path + '/saved.json');
                final MostVariedController c = Get.find();
                final VirtuesController v = Get.find();
                if (!file.existsSync()) {
                  c.blood.value = 0;
                  c.bloodMax.value = 20;
                  c.will.value = 0;
                  v.additionalWillpower.value = 5;
                } else {
                  Map<String, dynamic> json =
                      jsonDecode(file.readAsStringSync());

                  final blood = json["blood"];
                  final will = json["will"];
                  final bloodMax = json["blood_max"];
                  final willMax = json["will_max"];

                  c.blood.value = blood;
                  c.bloodMax.value = bloodMax;
                  c.will.value = will;
                  v.additionalWillpower.value = willMax;
                }
              });
            },
            icon: Icon(Icons.read_more),
          ),
          IconButton(
            onPressed: () {
              getApplicationDocumentsDirectory().then((value) {
                File file = File(value.path + '/saved.json');

                Map<String, dynamic> json = Map();
                final MostVariedController c = Get.find();
                final VirtuesController v = Get.find();

                json["blood"] = c.blood.value;
                json["blood_max"] = c.bloodMax.value;
                json["will"] = c.will.value;
                json["will_max"] = v.additionalWillpower.value;

                file.writeAsStringSync(jsonEncode(json));
              });
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _body,
      drawer: Drawer(
        child: DrawerMenu(_item),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'character.dart';
import 'advanatages_widget.dart';
import 'merits_and_flaws.dart';
import 'disciplines.dart';
import 'drawer_menu.dart';
import 'main_info_widget.dart';
import 'attributes.dart';

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    final VampireCharacter vc = Get.put(VampireCharacter());
    vc.initialize();
    vc.load();

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

// Abilities Menu

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
              final VampireCharacter vc = Get.find();
              vc.load();
            },
            icon: Icon(Icons.read_more),
          ),
          IconButton(
            onPressed: () {
              final VampireCharacter vc = Get.find();
              vc.save();
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

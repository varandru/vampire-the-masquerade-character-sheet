import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'abilities.dart';
import 'advanatages.dart';
import 'combat.dart';
import 'merits_and_flaws.dart';
import 'disciplines.dart';
import 'drawer_menu.dart';
import 'main_info.dart';
import 'attributes.dart';

const headerText = "Header text goes here";

final bloodPoolProvider = StateProvider((ref) => 0);
final willpowerProvider = StateProvider((ref) => 0);

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(home: primaryInfoScaffold);
  }
}

final primaryInfoScaffold = MenuScaffold(
    name: "Primary Information",
    body: ListView(
      children: [
        CommonCharacterInfoWidget(),
        AttributesSectionWidget(),
        AdvantagesWidget(),
      ],
      shrinkWrap: true,
      primary: true,
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
    ),
    item: SelectedMenuItem.PrimaryInfo);

// Abilities Menu
final abilitiesScaffold = MenuScaffold(
  name: "Abilities",
  body: ListView(
    children: [
      AbilitiesSectionWidget(),
    ],
  ),
  item: SelectedMenuItem.Abilities,
);

// Disciplines Menu
final disciplinesScaffold = MenuScaffold(
  name: "Disciplines",
  body: ListView(
    children: [
      DisciplinesSectionWidget(),
    ],
  ),
  item: SelectedMenuItem.Disciplines,
);

// Disciplines Menu
final meritsFlawsScaffold = MenuScaffold(
  name: "Merits & Flaws",
  body: MeritsAndFlawsSectionWidget(),
  item: SelectedMenuItem.Disciplines,
);

// Disciplines Menu
final weaponsArmorScaffold = MenuScaffold(
  name: "Weapons & Armor",
  body: WeaponsAndArmorSectionWidget(),
  item: SelectedMenuItem.WeaponsArmor,
);

class MenuScaffold extends ConsumerWidget {
  MenuScaffold(
      {required String name,
      required Widget body,
      required SelectedMenuItem item})
      : _name = name,
        _body = body,
        _item = item;

  final String _name;
  final Widget _body;
  final SelectedMenuItem _item;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        actions: [
          IconButton(
            onPressed: () {
              getApplicationDocumentsDirectory().then((value) {
                File file = File(value.path + '/saved.json');

                if (!file.existsSync()) {
                  context.read(bloodPoolProvider).state = 0;
                  context.read(willpowerProvider).state = 0;
                } else {
                  Map<String, dynamic> json =
                      jsonDecode(file.readAsStringSync());

                  final blood = json["blood"];
                  final will = json["will"];

                  context.read(bloodPoolProvider).state = blood;
                  context.read(willpowerProvider).state = will;
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

                final blood = context.read(bloodPoolProvider).state;
                final will = context.read(willpowerProvider).state;

                json["blood"] = blood;
                json["will"] = will;

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

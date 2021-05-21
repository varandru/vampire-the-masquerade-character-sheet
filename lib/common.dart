import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'abilities.dart';
import 'advanatages.dart';
import 'combat.dart';
import 'defs.dart';
import 'merits_and_flaws.dart';
import 'disciplines.dart';
import 'drawer_menu.dart';
import 'main_info.dart';
import 'attributes.dart';

const headerText = "Header text goes here";

void saveToJson() async {
  final container = ProviderContainer();
  Map<String, dynamic> json = Map();

  json["blood"] = container.read(bloodPoolProvider).state;
  json["will"] = container.read(willpowerProvider).state;

  File file =
      File((await getApplicationDocumentsDirectory()).path + 'saved.json');

  file.writeAsStringSync(jsonEncode(json));
}

final List<Widget> actions = [
  IconButton(
    onPressed: () => null,
    icon: Icon(Icons.save),
  ),
];

final primaryInfoScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Primary Information"),
    actions: actions,
  ),
  body: ListView(
    children: [
      CommonCharacterInfoWidget(),
      Container(
        child: AttributesSectionWidget(),
        constraints: BoxConstraints(maxHeight: 650, minHeight: 250),
      ),
      Container(
        child: AdvantagesWidget(),
        constraints: BoxConstraints(maxHeight: 650, minHeight: 250),
      ),
    ],
    shrinkWrap: true,
    primary: true,
    // mainAxisAlignment: MainAxisAlignment.start,
    // mainAxisSize: MainAxisSize.min,
  ),
  drawer: Drawer(
    child: DrawerMenu(SelectedMenuItem.PrimaryInfo),
  ),
);

// Abilities Menu
final abilitiesScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Abilities"),
    actions: actions,
  ),
  body: ListView(
    children: [
      AbilitiesSectionWidget(),
    ],
  ),
  drawer: Drawer(
    child: DrawerMenu(SelectedMenuItem.Abilities),
  ),
);

// Disciplines Menu
final disciplinesScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Disciplines"),
    actions: actions,
  ),
  body: ListView(
    children: [
      DisciplinesSectionWidget(),
    ],
  ),
  drawer: Drawer(
    child: DrawerMenu(SelectedMenuItem.Disciplines),
  ),
);

// Disciplines Menu
final meritsFlawsScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Merits & Flaws"),
    actions: actions,
  ),
  body: MeritsAndFlawsSectionWidget(),
  drawer: Drawer(
    child: DrawerMenu(SelectedMenuItem.Disciplines),
  ),
);

// Disciplines Menu
final weaponsArmorScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Weapons & Armor"),
    actions: actions,
  ),
  body: WeaponsAndArmorSectionWidget(),
  drawer: Drawer(
    child: DrawerMenu(SelectedMenuItem.WeaponsArmor),
  ),
);

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    final container = ProviderContainer();

    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + 'saved.json');
      Map<String, dynamic> json = jsonDecode(file.readAsStringSync());

      container.read(bloodPoolProvider).state = json["blood"];
      container.read(willpowerProvider).state = json["will"];
    });
    return MaterialApp(home: primaryInfoScaffold);
  }
}

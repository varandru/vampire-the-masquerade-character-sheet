import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vampire_the_masquerade_character_sheet/abilities.dart';
import 'package:vampire_the_masquerade_character_sheet/advanatages.dart';
import 'package:vampire_the_masquerade_character_sheet/combat.dart';
import 'package:vampire_the_masquerade_character_sheet/merits_and_flaws.dart';

import 'disciplines.dart';
import 'drawer_menu.dart';
import 'main_info.dart';
import 'attributes.dart';

const headerText = "Header text goes here";

final primaryInfoScaffold = Scaffold(
  appBar: AppBar(
    title: const Text("Primary Information"),
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
    return MaterialApp(home: primaryInfoScaffold);
  }
}

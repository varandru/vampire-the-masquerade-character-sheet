import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vampire_the_masquerade_character_sheet/abilities.dart';
import 'package:vampire_the_masquerade_character_sheet/advanatages.dart';

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

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(home: primaryInfoScaffold);
  }
}

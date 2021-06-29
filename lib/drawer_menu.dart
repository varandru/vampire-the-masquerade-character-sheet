import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vampire_the_masquerade_character_sheet/ritual_widget.dart';
import 'package:vampire_the_masquerade_character_sheet/xp_widget.dart';
import 'abilities_widget.dart';
import 'advanatages_widget.dart';
import 'attributes_widget.dart';
import 'combat.dart';
import 'disciplines_widget.dart';
import 'merits_and_flaws_widget.dart';
import 'vampire_character_widget.dart';
import 'main_info_widget.dart';

enum SelectedMenuItem {
  PrimaryInfo,
  Abilities,
  Disciplines,
  MeritsFlaws,
  WeaponsArmor,
  XP
}

class DrawerMenu extends Drawer {
  DrawerMenu(SelectedMenuItem item) : _item = item;

  final SelectedMenuItem _item;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Primary information'),
            trailing: Icon(Icons.face),
            tileColor: _item == SelectedMenuItem.PrimaryInfo
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () => Get.offAll(() => PrimaryInfoScaffold(context)),
          ),
          ListTile(
            title: Text('Attributes & Abilities'),
            trailing: Icon(Icons.accessibility_new),
            tileColor: _item == SelectedMenuItem.Abilities
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () =>
                Get.offAll(() => AttributesAndAbilitiesScaffold(context)),
          ),
          ListTile(
            title: Text('Disciplines'),
            trailing: Icon(Icons.auto_awesome),
            tileColor: _item == SelectedMenuItem.Disciplines
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () => Get.offAll(() => DisciplinesScaffold(context)),
          ),
          ListTile(
            title: Text('Merits & Flaws'),
            trailing: Icon(Icons.exposure),
            tileColor: _item == SelectedMenuItem.MeritsFlaws
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () => Get.offAll(() => MeritsFlawsScaffold(context)),
          ),
          ListTile(
            title: Text('Weapons and Armor'),
            trailing: Icon(Icons.devices),
            tileColor: _item == SelectedMenuItem.WeaponsArmor
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () => Get.offAll(() => WeaponsAndArmorScaffold()),
          ),
          ListTile(
            title: Text('XP'),
            trailing: Icon(Icons.insights),
            tileColor: _item == SelectedMenuItem.XP
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () => Get.offAll(() => XpScaffold(context)),
          ),
          ListTile(
            title: Text('Close'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class PrimaryInfoScaffold extends MenuScaffold {
  // Context should probably go here. But it's not used yet, so w/e
  PrimaryInfoScaffold(BuildContext context)
      : super(
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
          floatingActionButton: CommonFloatingButton([
            AddBackgroundButton(context),
          ], context),
        );
}

class AttributesAndAbilitiesScaffold extends MenuScaffold {
  AttributesAndAbilitiesScaffold(BuildContext context)
      : super(
            name: "Attributes & Abilities",
            body: ListView(
              children: [
                AttributesSectionWidget(),
                AbilitiesSectionWidget(),
              ],
              shrinkWrap: true,
              primary: true,
            ),
            selectedItem: SelectedMenuItem.Abilities,
            floatingActionButton: CommonFloatingButton([
              AddKnowledgeButton(context),
              AddSkillsButton(context),
              AddTalentButton(context)
            ], context));
}

class WeaponsAndArmorScaffold extends MenuScaffold {
  WeaponsAndArmorScaffold()
      : super(
          name: "Weapons & Armor",
          body: WeaponsAndArmorSectionWidget(),
          selectedItem: SelectedMenuItem.WeaponsArmor,
        );
}

// Merits & Flaws Menu
class MeritsFlawsScaffold extends MenuScaffold {
  MeritsFlawsScaffold(BuildContext context)
      : super(
          name: "Merits & Flaws",
          body: MeritsAndFlawsSectionWidget(),
          selectedItem: SelectedMenuItem.MeritsFlaws,
          floatingActionButton: CommonFloatingButton(
              [AddFlawButton(context), AddMeritButton(context)], context),
        );
}

// Disciplines Menu
class DisciplinesScaffold extends MenuScaffold {
  DisciplinesScaffold(BuildContext context)
      : super(
          name: "Disciplines",
          body: ListView.builder(
            itemBuilder: (context, i) =>
                (i == 0) ? DisciplinesSectionWidget() : RitualSectionWidget(),
            itemCount: 2,
          ),
          selectedItem: SelectedMenuItem.Disciplines,
          floatingActionButton: CommonFloatingButton(
              [AddDisciplineButton(context), AddRitualButton(context)],
              context),
        );
}

// XP Menu
class XpScaffold extends MenuScaffold {
  XpScaffold(BuildContext context)
      : super(
          name: "XP log",
          body: XpSectionWidget(),
          selectedItem: SelectedMenuItem.XP,
          floatingActionButton:
              CommonFloatingButton([XpEntryNewAbilityButton(context)], context),
        );
}

// ignore: must_be_immutable
class CommonFloatingButton extends SpeedDial {
  CommonFloatingButton(List<SpeedDialChild> children, BuildContext context)
      : super(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            closeManually: true,
            children: children);
}

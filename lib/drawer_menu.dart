import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vampire_the_masquerade_character_sheet/ritual_widget.dart';
import 'package:vampire_the_masquerade_character_sheet/settings_widget.dart';
import 'package:vampire_the_masquerade_character_sheet/xp_widget.dart';
import 'abilities_widget.dart';
import 'background_widget.dart';
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
  XP,
  Settings
}

class DrawerMenu extends Drawer {
  DrawerMenu(SelectedMenuItem item)
      : super(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(child: Container()),
              ListTile(
                title: Text('Primary information'),
                trailing: Icon(Icons.face),
                selected: item == SelectedMenuItem.PrimaryInfo,
                onTap: () => Get.offAll(() => PrimaryInfoScaffold()),
              ),
              ListTile(
                title: Text('Attributes & Abilities'),
                trailing: Icon(Icons.accessibility_new),
                selected: item == SelectedMenuItem.Abilities,
                onTap: () => Get.offAll(() => AttributesAndAbilitiesScaffold()),
              ),
              ListTile(
                title: Text('Disciplines'),
                trailing: Icon(Icons.auto_awesome),
                selected: item == SelectedMenuItem.Disciplines,
                onTap: () => Get.offAll(() => DisciplinesScaffold()),
              ),
              ListTile(
                title: Text('Merits & Flaws'),
                trailing: Icon(Icons.exposure),
                selected: item == SelectedMenuItem.MeritsFlaws,
                onTap: () => Get.offAll(() => MeritsFlawsScaffold()),
              ),
              ListTile(
                title: Text('Weapons and Armor'),
                trailing: Icon(Icons.devices),
                selected: item == SelectedMenuItem.WeaponsArmor,
                onTap: () => Get.offAll(() => WeaponsAndArmorScaffold()),
              ),
              ListTile(
                title: Text('XP'),
                trailing: Icon(Icons.insights),
                selected: item == SelectedMenuItem.XP,
                onTap: () => Get.offAll(() => XpScaffold()),
              ),
              ListTile(
                title: Text('Settings'),
                trailing: Icon(Icons.settings),
                selected: item == SelectedMenuItem.Settings,
                onTap: () => Get.offAll(() => SettingsScaffold()),
              ),
            ],
          ),
        );
}

class PrimaryInfoScaffold extends MenuScaffold {
  PrimaryInfoScaffold()
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
          floatingActionButton: CommonFloatingButton([AddBackgroundButton()]),
        );
}

class AttributesAndAbilitiesScaffold extends MenuScaffold {
  AttributesAndAbilitiesScaffold()
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
            floatingActionButton: CommonFloatingButton(
                [AddKnowledgeButton(), AddSkillsButton(), AddTalentButton()]));
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
  MeritsFlawsScaffold()
      : super(
          name: "Merits & Flaws",
          body: MeritsAndFlawsSectionWidget(),
          selectedItem: SelectedMenuItem.MeritsFlaws,
          floatingActionButton:
              CommonFloatingButton([AddFlawButton(), AddMeritButton()]),
        );
}

// Disciplines Menu
class DisciplinesScaffold extends MenuScaffold {
  DisciplinesScaffold()
      : super(
          name: "Disciplines",
          body: ListView.builder(
            itemBuilder: (context, i) =>
                (i == 0) ? DisciplinesSectionWidget() : RitualSectionWidget(),
            itemCount: 2,
          ),
          selectedItem: SelectedMenuItem.Disciplines,
          floatingActionButton:
              CommonFloatingButton([AddDisciplineButton(), AddRitualButton()]),
        );
}

// XP Menu
class XpScaffold extends MenuScaffold {
  XpScaffold()
      : super(
          name: "XP log",
          body: XpSectionWidget(),
          selectedItem: SelectedMenuItem.XP,
          floatingActionButton: CommonFloatingButton([
            XpEntryNewAbilityButton(),
            XpEntryUpgradedAbilityButton(),
            AddXpEntryGainedButton()
          ]),
          actions: [RecalculateXpButton()],
        );
}

// Settings Menu
class SettingsScaffold extends MenuScaffold {
  SettingsScaffold()
      : super(
          name: "Settings",
          body: SettingsSection(),
          selectedItem: SelectedMenuItem.Settings,
        );
}

// ignore: must_be_immutable
class CommonFloatingButton extends SpeedDial {
  CommonFloatingButton(List<SpeedDialChild> children)
      : super(
            icon: Icons.add,
            activeIcon: Icons.close,
            closeManually: true,
            children: children,
            backgroundColor: Colors.redAccent);
}

class CommonSpeedDialChild extends SpeedDialChild {
  CommonSpeedDialChild(
      {Widget? child,
      Color? backgroundColor,
      String? label,
      void Function()? onTap})
      : super(
            child: child,
            backgroundColor: backgroundColor,
            label: label,
            onTap: onTap,
            labelBackgroundColor:
                Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50);
}

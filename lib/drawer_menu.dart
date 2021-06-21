import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'abilities_widget.dart';
import 'advanatages_widget.dart';
import 'attributes_widget.dart';
import 'combat.dart';
import 'vampire_character_widget.dart';
import 'main_info_widget.dart';

enum SelectedMenuItem {
  PrimaryInfo,
  Abilities,
  Disciplines,
  MeritsFlaws,
  WeaponsArmor
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
            onTap: () {
              Get.offAll(
                () => PrimaryInfoScaffold(context),
              );
            },
          ),
          ListTile(
              title: Text('Attributes & Abilities'),
              trailing: Icon(Icons.accessibility_new),
              tileColor: _item == SelectedMenuItem.Abilities
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
              onTap: () {
                Get.offAll(
                  () => AttributesAndAbilitiesScaffold(context),
                );
              }),
          // ListTile(
          //   title: Text('Disciplines'),
          //   trailing: Icon(Icons.auto_awesome),
          //   tileColor: _item == SelectedMenuItem.Disciplines
          //       ? Theme.of(context).colorScheme.primary
          //       : Theme.of(context).colorScheme.onPrimary,
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacement(MaterialPageRoute(builder: (context) {
          //       return disciplinesScaffold;
          //     }));
          //   },
          // ),
          // ListTile(
          //   title: Text('Merits & Flaws'),
          //   trailing: Icon(Icons.exposure),
          //   tileColor: _item == SelectedMenuItem.MeritsFlaws
          //       ? Theme.of(context).colorScheme.primary
          //       : Theme.of(context).colorScheme.onPrimary,
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacement(MaterialPageRoute(builder: (context) {
          //       return meritsFlawsScaffold;
          //     }));
          //   },
          // ),
          ListTile(
            title: Text('Weapons and Armor'),
            trailing: Icon(Icons.devices),
            tileColor: _item == SelectedMenuItem.WeaponsArmor
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            onTap: () {
              Get.offAll(
                () => WeaponsAndArmorScaffold(),
              );
            },
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
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            closeManually: true,
            children: [
              AddBackgroundButton(context),
            ],
          ),
        );
}

class AttributesAndAbilitiesScaffold extends MenuScaffold {
  AttributesAndAbilitiesScaffold(BuildContext context)
      : super(
          name: "Attributes & Abilities",
          body: ListView(
            children: [
              // AttributesSectionWidget(),
              // AbilitiesSectionWidget(),
            ],
            shrinkWrap: true,
            primary: true,
          ),
          selectedItem: SelectedMenuItem.Abilities,
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            closeManually: true,
            children: [
              SpeedDialChild(
                child: Icon(Icons.psychology_outlined),
                backgroundColor: Colors.blue.shade300,
                label: "Add a mental attribute",
                labelBackgroundColor: Theme.of(context).colorScheme.surface,
              ),
              SpeedDialChild(
                child: Icon(Icons.sentiment_very_satisfied_outlined),
                backgroundColor: Colors.green.shade300,
                label: "Add a social attribute",
                labelBackgroundColor: Theme.of(context).colorScheme.surface,
              ),
              SpeedDialChild(
                child: Icon(Icons.directions_run_rounded),
                backgroundColor: Colors.red.shade300,
                label: "Add a physical attribute",
                labelBackgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          ),
        );
}

class WeaponsAndArmorScaffold extends MenuScaffold {
  WeaponsAndArmorScaffold()
      : super(
          name: "Weapons & Armor",
          body: WeaponsAndArmorSectionWidget(),
          selectedItem: SelectedMenuItem.WeaponsArmor,
        );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'advanatages.dart';
import 'combat.dart';
import 'common.dart';
import 'main_info.dart';

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
                () => MenuScaffold(
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
            },
          ),
          // ListTile(
          //   title: Text('Abilities'),
          //   trailing: Icon(Icons.accessibility_new),
          //   tileColor: _item == SelectedMenuItem.Abilities
          //       ? Theme.of(context).colorScheme.primary
          //       : Theme.of(context).colorScheme.onPrimary,
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacement(MaterialPageRoute(builder: (context) {
          //       return abilitiesScaffold;
          //     }));
          //   },
          // ),
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
              // Navigator.of(context)
              //     .pushReplacement(MaterialPageRoute(builder: (context) {
              //   return weaponsArmorScaffold;
              // }));
              Get.offAll(
                () => MenuScaffold(
                  name: "Weapons & Armor",
                  body: WeaponsAndArmorSectionWidget(),
                  selectedItem: SelectedMenuItem.WeaponsArmor,
                ),
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

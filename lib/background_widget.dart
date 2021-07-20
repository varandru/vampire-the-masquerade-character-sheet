import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

import 'backgrounds.dart';
import 'common_logic.dart';
import 'common_widget.dart';
import 'damage_widget.dart';
import 'drawer_menu.dart';
import 'virtues_widget.dart';

const maxBloodCount = 20;
const maxWillpowerCount = 10;

class BackgroundColumnWidget extends ComplexAbilityColumnWidget {
  BackgroundColumnWidget() {
    BackgroundsController bc = Get.find();
    super.name = bc.backgrounds.value.name;
    super.values = bc.backgrounds.value.values;
    super.editValue = bc.backgrounds.value.editValue;
    super.description = bc.backgrounds.value.description;
    super.deleteValue = bc.backgrounds.value.deleteValue;

    bc.fromDatabase(Get.find<DatabaseController>().database);
  }
}

class AdvantagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Advantages", style: Theme.of(context).textTheme.headline4),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            BackgroundColumnWidget(),
            VirtuesColumnWidget(),
            SummarizedInfoWidgetTop(),
            Row(
              children: [
                Flexible(child: SummarizedInfoWidgetBottom()),
                Flexible(child: DamageSection()),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            Container(height: 70)
          ],
        ),
      ],
    );
  }
}

class AddBackgroundButton extends CommonSpeedDialChild {
  AddBackgroundButton()
      : super(
          child: Icon(Icons.groups),
          backgroundColor: Colors.yellow.shade300,
          label: "Add custom background",
          // labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            final cap =
                await Get.dialog<ComplexAbilityPair>(ComplexAbilityDialog(
              name: 'New Background',
              hasSpecializations: false,
            ));
            if (cap != null) {
              BackgroundsController bc = Get.find();
              bc.backgrounds.value.add(cap.ability);

              DatabaseController dc = Get.find();

              dc.database
                  .insert(
                      'backgrounds',
                      {
                        'id': cap.entry.databaseId,
                        'txt_id': cap.ability.txtId,
                        'name': cap.entry.name,
                        'description': cap.entry.description,
                      },
                      conflictAlgorithm: ConflictAlgorithm.rollback)
                  .then((value) => dc.database.insert('player_backgrounds', {
                        'player_id': dc.characterId.value,
                        'background_id': value,
                        'current': cap.ability.current,
                      }));
            }
          },
        );
}

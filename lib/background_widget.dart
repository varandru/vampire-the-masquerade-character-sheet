import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'backgrounds.dart';
import 'common_widget.dart';
import 'common_logic.dart';
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
            SummarizedInfoWidget(),
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
            final ca = await Get.dialog<ComplexAbility>(ComplexAbilityDialog(
              name: 'New Background',
              hasSpecializations: false,
            ));
            if (ca != null) {
              BackgroundsController bc = Get.find();
              bc.backgrounds.value.add(ca);
            }
          },
        );
}

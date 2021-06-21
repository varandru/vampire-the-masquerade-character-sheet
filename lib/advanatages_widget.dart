import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/advantages.dart';

import 'common_widget.dart';
import 'common_logic.dart';
import 'main_info.dart';

const maxBloodCount = 20;
const maxWillpowerCount = 10;

// Are separated on the character sheet. Go into primary info in the app.
// This is hardcoded for the sake of the fast hardcoded version.
// TODO: serialize, allow arbitrary backgrounds
class BackgroundColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BackgroundsController bc = Get.find();
    String header = "Backgrounds";

    List<Widget> column = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in bc.backgrounds) {
      column.add(ComplexAbilityWidget(
        attribute: attr,
      ));
    }

    return Column(
      children: column,
      // padding: EdgeInsets.zero,
    );
  }
}

class VirtuesColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VirtuesController vc = Get.find();
    String header = "Virtues";

    List<Widget> column = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    column.add(Obx(() => ComplexAbilityWidget(
        attribute:
            ComplexAbility(name: "Conscience", current: vc.consience.value))));
    column.add(Obx(() => ComplexAbilityWidget(
        attribute: ComplexAbility(
            name: "Self-Control", current: vc.selfControl.value))));
    column.add(Obx(() => ComplexAbilityWidget(
        attribute:
            ComplexAbility(name: "Courage", current: vc.courage.value))));

    return Column(children: column);
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

class SummarizedInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noTitleRestraint = BoxConstraints(
        maxHeight: 22, minHeight: 22, maxWidth: 220, minWidth: 220);

    List<Widget> elements = [];

    final MostVariedController mvc = Get.find();
    final VirtuesController vc = Get.find();

    // Humanity
    elements.add(Text(
      "Humanity",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));
    elements.add(Container(
      child: NoTitleCounterWidget(current: 5),
      constraints: noTitleRestraint,
    ));

    // Willpower
    elements.add(Text(
      "Willpower",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));
    elements.add(Container(
      child: Obx(() =>
          NoTitleCounterWidget(current: vc.willpower, max: maxWillpowerCount)),
      constraints: noTitleRestraint,
    ));
    elements.add(
      Obx(() => Wrap(
            children: makeWillPowerRow(mvc.will.value, vc.willpower),
          )),
    );

    elements.add(Text(
      "Bloodpool",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));

    elements.add(
      Obx(() => Wrap(
            children: makeBloodPoolRow(mvc.blood.value, mvc.bloodMax.value),
          )),
    );

    return Column(
      children: elements,
      // mainAxisSize: MainAxisSize.min,
    );
    // );
  }

  List<Widget> makeBloodPoolRow(int current, int localMax) {
    List<Widget> row = [];
    final MostVariedController c = Get.find();
    for (int i = 0; i < current; i++) {
      row.add(IconButton(
        icon: Icon(Icons.add_box),
        iconSize: 20,
        onPressed: () => c.blood.value = i,
      ));
    }
    for (int i = current; i < localMax; i++) {
      row.add(IconButton(
        icon: Icon(Icons.check_box_outline_blank),
        iconSize: 20,
        onPressed: () => c.blood.value = i + 1,
      ));
    }
    for (int i = localMax; i < maxBloodCount; i++) {
      row.add(Icon(Icons.select_all, size: 20));
    }

    return row;
  }

  List<Widget> makeWillPowerRow(int current, int localMax) {
    List<Widget> row = [];
    final MostVariedController c = Get.find();
    for (int i = 0; i < current; i++) {
      row.add(IconButton(
        icon: Icon(Icons.add_box),
        iconSize: 20,
        onPressed: () => c.will.value = i,
      ));
    }
    for (int i = current; i < localMax; i++) {
      row.add(IconButton(
        icon: Icon(Icons.check_box_outline_blank),
        iconSize: 20,
        onPressed: () => c.will.value = i + 1,
      ));
    }
    for (int i = localMax; i < maxWillpowerCount; i++) {
      row.add(Icon(Icons.select_all, size: 20));
    }

    return row;
  }
}

class AddBackgroundButton extends SpeedDialChild {
  AddBackgroundButton(BuildContext context)
      : super(
          child: Icon(Icons.groups),
          backgroundColor: Colors.yellow.shade300,
          label: "Add custom background",
          labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            // final ca =
            //     await Get.dialog<ComplexAbility>(AddComplexAbilityDialog());
            // if (ca != null) {
            //   BackgroundsController bc = Get.find();
            //   bc.addBackground(ca);
            // }
          },
        );
}

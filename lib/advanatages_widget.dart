import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'attributes.dart';
import 'attributes_widget.dart';
import 'defs.dart';
import 'main_info.dart';

const maxBloodCount = 20;
const maxWillpowerCount = 10;

// Are separated on the character sheet. Go into primary info in the app.
// This is hardcoded for the sake of the fast hardcoded version.
// TODO: serialize, allow arbitrary backgrounds
class BackgroundColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String header = "Backgrounds";
    List<Attribute> attributes = [
      Attribute(name: "Mentor", current: 2),
      Attribute(name: "Herd", current: 1),
      Attribute(name: "Resources", current: 2),
      Attribute(name: "Generation", current: 3),
    ];

    List<Widget> column = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in attributes) {
      column.add(AttributeWidget(attribute: attr));
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
    String header = "Virtues";
    List<Attribute> attributes = [
      Attribute(name: "Conscience", current: 2),
      Attribute(name: "Self-Control", current: 3),
      Attribute(name: "Courage", current: 5),
    ];

    List<Widget> column = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in attributes) {
      column.add(AttributeWidget(attribute: attr));
    }

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

    // TODO: humanity logic, huh
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

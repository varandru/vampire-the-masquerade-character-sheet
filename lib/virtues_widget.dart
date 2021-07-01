import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'advanatages_widget.dart';
import 'common_logic.dart';
import 'common_widget.dart';
import 'main_info.dart';
import 'virtues.dart';

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
          attribute: ComplexAbility(
            name: "Conscience",
            current: vc.consience.value,
            min: 1,
            isDeletable: false,
            isNameEditable: false,
          ),
          updateCallback: (ability, index) =>
              vc.consience.value = ability.current,
          deleteCallback: (index) => null,
        )));
    column.add(Obx(() => ComplexAbilityWidget(
          attribute: ComplexAbility(
            name: "Self-Control",
            current: vc.selfControl.value,
            min: 1,
            isDeletable: false,
            isNameEditable: false,
          ),
          updateCallback: (ability, index) =>
              vc.selfControl.value = ability.current,
          deleteCallback: (index) => null,
        )));
    column.add(Obx(() => ComplexAbilityWidget(
          attribute: ComplexAbility(
            name: "Courage",
            current: vc.courage.value,
            min: 1,
            isDeletable: false,
            isNameEditable: false,
          ),
          updateCallback: (ability, index) =>
              vc.courage.value = ability.current,
          deleteCallback: (index) => null,
        )));

    return Container(
      child: ListView(
        children: column,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
      constraints: BoxConstraints(maxWidth: 500),
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

    Color highlightColor = Theme.of(context).accentColor;

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
      Obx(() => SquareButtonsRow(mvc.will.value, vc.willpower, 20,
              (value) => mvc.will.value = value,
              highlight: highlightColor)
          // Wrap(children: makeWillPowerRow(mvc.will.value, vc.willpower))
          ),
    );

    elements.add(Text(
      "Bloodpool",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));

    elements.add(
      Obx(() => SquareButtonsRow(mvc.blood.value, mvc.bloodMax.value, 20,
              (value) => mvc.blood.value = value,
              highlight: highlightColor)
          // Wrap(children: makeBloodPoolRow(mvc.blood.value, mvc.bloodMax.value))
          ),
    );

    return Column(
      children: elements,
      // mainAxisSize: MainAxisSize.min,
    );
    // );
  }
}

class SquareButtonsRow extends StatelessWidget {
  SquareButtonsRow(this.current, this.localMax, this.max, this.update,
      {this.highlight});

  final int current;
  final int localMax;
  final int max;
  final Function(int) update;
  final Color? highlight;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [];
    for (int i = 0; i < current; i++) {
      row.add(IconButton(
        icon: Icon(
          Icons.add_box,
          color: ((i + 1) % 5 == 0) ? highlight : null,
        ),
        iconSize: 20,
        onPressed: () => update(i),
      ));
    }
    for (int i = current; i < localMax; i++) {
      row.add(IconButton(
        icon: Icon(
          Icons.check_box_outline_blank,
          color: ((i + 1) % 5 == 0) ? highlight : null,
        ),
        iconSize: 20,
        onPressed: () => update(i + 1),
      ));
    }
    for (int i = localMax; i < maxWillpowerCount; i++) {
      row.add(IconButton(
        icon: Icon(Icons.disabled_by_default),
        onPressed: () => null,
      ));
    }

    return Wrap(children: row);
  }
}

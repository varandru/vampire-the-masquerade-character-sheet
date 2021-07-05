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
            id: 'consience',
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
            id: 'selfcontrol',
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
            id: 'courage',
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
    elements.add(
      Container(
        child: InkWell(
          child: Obx(() => NoTitleCounterWidget(current: vc.humanity)),
          onTap: () async {
            var val = await Get.dialog<int>(
                SingleNumberEditor(vc.humanity, "Edit Humanity"));
            if (val != null) {
              vc.additionalHumanity.value += val - vc.humanity;
            }
          },
        ),
        constraints: noTitleRestraint,
      ),
    );

    // Willpower
    elements.add(Text(
      "Willpower",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));
    elements.add(Container(
      child: InkWell(
        child: Obx(() => NoTitleCounterWidget(
              current: vc.willpower,
              max: maxWillpowerCount,
            )),
        onTap: () async {
          var val = await Get.dialog<int>(
              SingleNumberEditor(vc.willpower, "Edit Willpower maximum"));
          if (val != null) {
            vc.additionalWillpower.value += val - vc.willpower;
          }
        },
      ),
      constraints: noTitleRestraint,
    ));
    elements.add(
      Obx(() => SquareButtonsRow(mvc.will.value, vc.willpower, 20,
              (value) => mvc.will.value = value,
              highlight: highlightColor)
          // Wrap(children: makeWillPowerRow(mvc.will.value, vc.willpower))
          ),
    );

    elements.add(
      InkWell(
          child: Text(
            "Bloodpool",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          onTap: () async {
            var val = await Get.dialog<int>(SingleNumberEditor(
                mvc.bloodMax.value, "Edit Bloodpool maximum"));
            if (val != null) {
              mvc.bloodMax.value = val;
            }
          }),
    );

    elements.add(
      Obx(() => SquareButtonsRow(mvc.blood.value, mvc.bloodMax.value, 20,
          (value) => mvc.blood.value = value,
          highlight: highlightColor)),
    );

    // return Column(
    //   children: elements,
    // );

    return ListView.builder(
      itemBuilder: (context, i) {
        switch (i) {
          case 0:
            return Text(
              "Humanity",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            );
          case 1:
            return Container(
                child: InkWell(
                    child: Obx(() => NoTitleCounterWidget(
                          current: vc.humanity,
                          max: 10,
                        )),
                    onTap: () async {
                      var val = await Get.dialog<int>(SingleNumberEditor(
                        vc.humanity,
                        "Edit Humanity",
                        max: 10,
                      ));
                      if (val != null) {
                        vc.additionalHumanity.value += val - vc.humanity;
                      }
                    }),
                constraints: noTitleRestraint);
          case 2:
            return Text(
              "Willpower",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            );
          case 3:
            return Container(
              child: InkWell(
                child: Obx(() => NoTitleCounterWidget(
                      current: vc.willpower,
                      max: maxWillpowerCount,
                    )),
                onTap: () async {
                  var val = await Get.dialog<int>(SingleNumberEditor(
                    vc.willpower,
                    "Edit Willpower maximum",
                    max: 10,
                  ));
                  if (val != null) {
                    vc.additionalWillpower.value += val - vc.willpower;
                  }
                },
              ),
              constraints: noTitleRestraint,
            );
          case 4:
            return Obx(() => SquareButtonsRow(mvc.will.value, vc.willpower,
                    maxWillpowerCount, (value) => mvc.will.value = value,
                    highlight: highlightColor)
                // Wrap(children: makeWillPowerRow(mvc.will.value, vc.willpower))
                );
          case 5:
            return InkWell(
                child: Text(
                  "Bloodpool",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                onTap: () async {
                  var val = await Get.dialog<int>(SingleNumberEditor(
                    mvc.bloodMax.value,
                    "Edit Bloodpool maximum",
                    max: 20,
                  ));
                  if (val != null) {
                    mvc.bloodMax.value = val;
                    if (mvc.blood > val) mvc.blood.value = val;
                  }
                });
          case 6:
            return Obx(() => SquareButtonsRow(
                mvc.blood.value,
                mvc.bloodMax.value,
                maxBloodCount,
                (value) => mvc.blood.value = value,
                highlight: highlightColor));
          default:
            return Placeholder();
        }
      },
      itemCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
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
    for (int i = localMax; i < max; i++) {
      row.add(IconButton(
        icon: Icon(Icons.disabled_by_default),
        onPressed: () => null,
      ));
    }

    return Wrap(children: row);
  }
}

class SingleNumberEditor extends StatelessWidget {
  SingleNumberEditor(this.value, this.title, {this.min = 0, this.max = 10});

  final String title;
  final int value;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    var current = value.obs;

    return SimpleDialog(
      title: Text(title),
      children: [
        Row(
          children: [
            Text('Current Value: '),
            IconButton(
                onPressed: () => current.value > min ? current-- : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                )),
            Obx(() => Text("${current.value}")),
            IconButton(
                onPressed: () => current.value < max ? current++ : null,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                )),
          ],
        ),
        Row(
          children: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(result: null),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () => Get.back(result: current.value),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ],
    );
  }
}

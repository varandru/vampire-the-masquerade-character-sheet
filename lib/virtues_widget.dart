import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'background_widget.dart';
import 'common_widget.dart';
import 'main_info.dart';
import 'virtues.dart';

class VirtuesColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String header = "Virtues";
    return Container(
      child: ListView(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          Obx(() => ConscienceWidget()),
          Obx(() => SelfControlWidget()),
          Obx(() => CourageWidget()),
        ],
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
      constraints: BoxConstraints(maxWidth: 500),
    );
  }
}

abstract class VirtueWidget extends StatelessWidget {
  VirtueWidget({
    required this.name,
    required this.current,
    required this.onTap,
  });

  final String name;
  final int current;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: NoTitleCounterWidget(
        current: current,
        max: 5,
      ),
      onTap: onTap,
    );
  }
}

class ConscienceWidget extends VirtueWidget {
  ConscienceWidget()
      : super(
          name: 'Conscience',
          current: Get.find<VirtuesController>().conscience,
          onTap: () => Get.dialog(ConsciencePopup()),
        );
}

class SelfControlWidget extends VirtueWidget {
  SelfControlWidget()
      : super(
          name: 'Self-control',
          current: Get.find<VirtuesController>().selfControl,
          onTap: () => Get.dialog(SelfControlPopup()),
        );
}

class CourageWidget extends VirtueWidget {
  CourageWidget()
      : super(
          name: 'Courage',
          current: Get.find<VirtuesController>().courage,
          onTap: () => Get.dialog(CouragePopup()),
        );
}

/// Descriptions and alternative virtues are TBD. For now, let's just edit the
/// value in edit dialogue
abstract class VirtuePopup extends StatelessWidget {
  VirtuePopup(
      {required this.name, required this.level, required this.onEditClick});

  final String name;
  final int level;
  final Function() onEditClick;

  // Future<String> getDescription();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4),
        children: [
          NoTitleCounterWidget(
            current: level,
            max: 5,
            alignment: MainAxisAlignment.center,
          ),
          IconButton(onPressed: onEditClick, icon: Icon(Icons.edit))
        ],
      );
}

class ConsciencePopup extends VirtuePopup {
  ConsciencePopup()
      : super(
            name: 'Conscience',
            level: Get.find<VirtuesController>().conscience,
            onEditClick: () async {
              var n = await Get.dialog<int>(ConscienceDialog());
              if (n != null) {
                Get.find<VirtuesController>().conscience = n;
                Get.back();
              }
            });
}

class SelfControlPopup extends VirtuePopup {
  SelfControlPopup()
      : super(
            name: 'Self-Control',
            level: Get.find<VirtuesController>().selfControl,
            onEditClick: () async {
              var n = await Get.dialog<int>(SelfControlDialog());
              if (n != null) {
                Get.find<VirtuesController>().selfControl = n;
                Get.back();
              }
            });
}

class CouragePopup extends VirtuePopup {
  CouragePopup()
      : super(
            name: 'Courage',
            level: Get.find<VirtuesController>().courage,
            onEditClick: () async {
              var n = await Get.dialog<int>(CourageDialog());
              if (n != null) {
                Get.find<VirtuesController>().courage = n;
                Get.back();
              }
            });
}

abstract class VirtueEditWidget extends StatelessWidget {
  VirtueEditWidget({required this.name, required this.level});

  final String name;
  final int level;

  final int min = 0;
  final int max = 5;

  @override
  Widget build(BuildContext context) {
    var current = level.obs;

    return SimpleDialog(
      title: Text("Edit $name"),
      children: [
        Text(name),
        Row(
          children: [
            Text('Current Value: '),
            IconButton(
                onPressed: () {
                  if (current > min) current.value--;
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                )),
            Obx(() => Text("$current")),
            IconButton(
                onPressed: () {
                  if (current < max) current++;
                },
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
                onPressed: () => Get.back(result: current.value)),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ],
    );
  }
}

class ConscienceDialog extends VirtueEditWidget {
  ConscienceDialog()
      : super(
          name: 'Conscience',
          level: Get.find<VirtuesController>().conscience,
        );
}

class SelfControlDialog extends VirtueEditWidget {
  SelfControlDialog()
      : super(
          name: 'Self-Control',
          level: Get.find<VirtuesController>().selfControl,
        );
}

class CourageDialog extends VirtueEditWidget {
  CourageDialog()
      : super(
          name: 'Courage',
          level: Get.find<VirtuesController>().courage,
        );
}

class SummarizedInfoWidgetTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noTitleRestraint = BoxConstraints(
        maxHeight: 22, minHeight: 22, maxWidth: 220, minWidth: 220);

    final VirtuesController vc = Get.find();

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
                        vc.humanity += val - vc.humanity;
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
                    vc.willpower += val - vc.willpower;
                  }
                },
              ),
              constraints: noTitleRestraint,
            );
          default:
            return Placeholder();
        }
      },
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}

class SummarizedInfoWidgetBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MostVariedController mvc = Get.find();
    final VirtuesController vc = Get.find();

    Color highlightColor = Theme.of(context).accentColor;

    return ListView.builder(
      itemBuilder: (context, i) {
        switch (i) {
          case 0:
            return Text(
              "Willpower",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            );
          case 1:
            return Obx(() => SquareButtonsRow(mvc.will, vc.willpower,
                    maxWillpowerCount, (value) => mvc.will = value,
                    highlight: highlightColor)
                // Wrap(children: makeWillPowerRow(mvc.will.value, vc.willpower))
                );
          case 2:
            return InkWell(
                child: Text(
                  "Bloodpool",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                onTap: () async {
                  var val = await Get.dialog<int>(SingleNumberEditor(
                    mvc.bloodMax,
                    "Edit Bloodpool maximum",
                    max: 20,
                  ));
                  if (val != null) {
                    mvc.bloodMax = val;
                    if (mvc.blood > val) mvc.blood = val;
                  }
                });
          case 3:
            return Obx(() => SquareButtonsRow(mvc.blood, mvc.bloodMax,
                maxBloodCount, (value) => mvc.blood = value,
                highlight: highlightColor));
          default:
            return Placeholder();
        }
      },
      itemCount: 4,
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

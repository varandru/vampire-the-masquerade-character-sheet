import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_logic.dart';

List<Widget> makeIconRow(
    int current, int max, IconData filled, IconData empty) {
  List<Widget> row = [];
  for (int i = 0; i < current; i++) {
    row.add(Icon(filled, size: 20));
  }
  for (int i = current; i < max; i++) {
    row.add(Icon(empty, size: 20));
  }
  return row;
}

class NoTitleCounterWidget extends StatelessWidget {
  NoTitleCounterWidget({int current = 0, int max = 10})
      : _current = current,
        _max = max;

  final _current;
  final _max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          makeIconRow(_current, _max, Icons.circle, Icons.circle_outlined),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

/// Displays attributes, abilities and virtues.
/// Anything that conforms to ComplexAbility structure, basically
class ComplexAbilityWidget extends StatelessWidget {
  ComplexAbilityWidget({
    Key? key,
    required ComplexAbility attribute,
    required this.updateCallback,
    required this.deleteCallback,
    this.index = 0,
  })  : this.attribute = attribute,
        super(key: key);

  final ComplexAbility attribute;
  final int index;
  final Function(ComplexAbility ability, int index) updateCallback;
  final Function(int index) deleteCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = makeIconRow(
        attribute.current, attribute.max, Icons.circle, Icons.circle_outlined);
    final header = Text(
      attribute.name,
      overflow: TextOverflow.fade,
      softWrap: false,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: ListTile(
        title: header,
        subtitle: Text(attribute.specialization),
        trailing: Row(
          children: row,
          mainAxisSize: MainAxisSize.min,
        ),
        onTap: () {
          List<Widget> children = [];
          if (attribute.specialization.isNotEmpty) {
            children.add(Text(attribute.specialization,
                style: Theme.of(context).textTheme.headline5));
          }
          if (attribute.description.isNotEmpty) {
            children.add(Text("Description:",
                style: Theme.of(context).textTheme.headline6));
            children.add(Text(attribute.description));
          }
          children.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    final ca = await Get.dialog<ComplexAbility>(
                        ComplexAbilityDialog(name: 'Edit ${attribute.name}'));
                    if (ca != null) {
                      updateCallback(ca, index);
                    }
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    await Get.defaultDialog(
                        middleText: "Delete ${attribute.name}?",
                        textConfirm: "Ok",
                        textCancel: "Cancel",
                        onConfirm: deleteCallback(index));
                  },
                  icon: Icon(Icons.delete)),
            ],
          ));
          Get.dialog(
            SimpleDialog(
              title: Text(
                attribute.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              children: children,
            ),
          );
        },
      ),
    );
  }
}

class ComplexAbilityColumnWidget extends StatelessWidget {
  ComplexAbilityColumnWidget();

  late ComplexAbilityColumn controller;

  @override
  Widget build(BuildContext context) {
    print(
        "Building ${controller.name}. It has ${controller.values.length} elements");
    List<Widget> column = [];

    column.add(Text(controller.name.value,
        style: Theme.of(context).textTheme.headline4));

    for (int i = 0; i < controller.values.length; i++) {
      column.add(Obx(() => ComplexAbilityWidget(
          attribute: controller.values[i],
          index: i,
          updateCallback: controller.editValue,
          deleteCallback: controller.deleteValue)));
    }
    return Column(
      children: column,
    );
  }
}

class ComplexAbilityDialog extends Dialog {
  ComplexAbilityDialog({
    this.ability,
    this.name = 'New Ability',
  });

  final String name;
  final ComplexAbility? ability;

  @override
  Widget build(BuildContext context) {
    var ca = (ability != null)
        ? ability!.obs
        : ComplexAbility(name: 'New Ability').obs;

    return SimpleDialog(
      title: Text(name),
      children: [
        Row(
          children: [
            Text('Name: '),
            Expanded(
              child: TextField(
                  onChanged: (value) => ca.update(
                        (val) {
                          val?.name = value;
                        },
                      )),
            ),
          ],
        ),
        Row(
          children: [
            Text('Current Value: '),
            IconButton(
                onPressed: () => ca.update((val) {
                      val?.current--;
                    }),
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                )),
            Obx(() => Text("${ca.value.current}")),
            IconButton(
                onPressed: () => ca.update((val) {
                      val?.current++;
                    }),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                )),
          ],
        ),
        Row(
          children: [
            Text('Description: '),
            Expanded(
              child: TextField(
                  onChanged: (value) => ca.update((val) {
                        val?.description = value;
                      })),
            ),
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
              onPressed: () {
                if (ca.value.name.isNotEmpty)
                  Get.back(result: ca.value);
                else
                  Get.back(result: null);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ],
    );
  }
}

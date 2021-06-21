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
    required this.callback,
    this.index = 0,
  })  : this.attribute = attribute,
        super(key: key);

  final ComplexAbility attribute;
  final int index;
  final Function(ComplexAbility ability, int index) callback;

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
  ComplexAbilityColumnWidget(this.controller);

  final ComplexAbilityColumn controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> column = [];

    column.add(Text(controller.name.value,
        style: Theme.of(context).textTheme.headline4));

    for (int i = 0; i < controller.values.length; i++) {
      column.add(ComplexAbilityWidget(
          attribute: controller.values[i],
          index: i,
          callback: controller.editValue));
    }
    return Column(
      children: column,
    );
  }
}

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
  ComplexAbilityWidget({Key? key, required ComplexAbility attribute})
      : this.attribute = attribute,
        super(key: key);

  final ComplexAbility attribute;

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
          // FIXME: this looks just awful. Do something
          if (attribute.specialization.isNotEmpty) {
            children.add(Text("Specialization",
                style: Theme.of(context).textTheme.headline4));
            children.add(Text(attribute.specialization));
          }
          children.add(Text("Description:",
              style: Theme.of(context).textTheme.headline6));
          children.add(Text(attribute.description));
          Get.dialog(
            SimpleDialog(
              title: Text(attribute.name),
              children: children,
            ),
          );
        },
      ),
    );
  }
}

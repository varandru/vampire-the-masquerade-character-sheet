import 'package:flutter/material.dart';

class Attribute {
  Attribute(
      {required String name,
      int current = 1,
      int max = 5,
      String specialization = ""})
      : this.name = name,
        this.current = current,
        this.max = max,
        this.specialization = specialization;
  String name;
  int current;
  int max;
  String specialization;
}

class AttributeWidget extends StatelessWidget {
  AttributeWidget({Key? key, required Attribute attribute})
      : this.attribute = attribute,
        super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [];
    for (int i = 0; i < attribute.current; i++) {
      row.add(Icon(Icons.circle));
    }
    for (int i = attribute.current; i < attribute.max; i++) {
      row.add(Icon(Icons.circle_outlined));
    }

    return ListTile(
      title: Text(
        attribute.name +
            (attribute.specialization.isNotEmpty
                ? " (" + attribute.specialization + ")"
                : ""),
        overflow: TextOverflow.fade,
      ),
      trailing: Row(
        children: row,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

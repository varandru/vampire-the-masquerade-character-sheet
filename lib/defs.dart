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

List<Widget> makeThreeIconRow(int current, int localMax, int max,
    IconData filled, IconData empty, IconData blocked) {
  List<Widget> row = [];
  for (int i = 0; i < current; i++) {
    row.add(Icon(filled, size: 20));
  }
  for (int i = current; i < localMax; i++) {
    row.add(Icon(empty, size: 20));
  }
  for (int i = localMax; i < max; i++) {
    row.add(Icon(blocked, size: 20));
  }
  return row;
}

class AttributeWidget extends StatelessWidget {
  AttributeWidget({Key? key, required Attribute attribute})
      : this.attribute = attribute,
        super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = makeIconRow(
        attribute.current, attribute.max, Icons.circle, Icons.circle_outlined);
    final header = Text(
      attribute.name +
          (attribute.specialization.isNotEmpty
              ? " (" + attribute.specialization + ")"
              : ""),
      overflow: TextOverflow.fade,
      softWrap: false,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      child: ListTile(
        title: header,
        trailing: Row(
          children: row,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class NoTitleCounterWidget extends StatelessWidget {
  NoTitleCounterWidget({int current = 0, int max = 10})
      : _current = current,
        _max = max;

  final _current;
  final _max;

  @override
  Widget build(BuildContext context) {
    List<Widget> row =
        makeIconRow(_current, _max, Icons.circle, Icons.circle_outlined);
    row.insert(0, Spacer());
    row.add(Spacer());

    return Row(
      children: row,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

// TODO: it's not... Y'know... Clickable
// But it really should be
class ClickableSquareCounterWidget extends StatelessWidget {
  ClickableSquareCounterWidget(
      {int current = 0, int localMax = 10, int max = 10})
      : _current = current,
        _max = max,
        _localMax = localMax;

  final _current;
  final _max;
  final _localMax;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = makeThreeIconRow(_current, _localMax, _max,
        Icons.add_box, Icons.check_box_outline_blank, Icons.select_all);
    row.insert(0, Spacer());
    row.add(Spacer());

    return Row(
      children: row,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'defs.dart';

// Are separated on the character sheet. Go into primary info in the app.
// This is hardcoded for the sake of the fast hardcoded version.
// TODO: serialize, allow arbutrary backgrounds
class BackgroundColumnWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String header = "Backgrounds";
    List<Attribute> attributes = [
      Attribute(name: "Mentor", current: 2),
      Attribute(name: "Herd", current: 1),
      Attribute(name: "Resources", current: 2),
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

class VirtuesColumnWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
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

class AdvantagesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Column(children: [
      Expanded(
        child: Row(
          children: [
            Flexible(child: BackgroundColumnWidget()),
            Flexible(child: VirtuesColumnWidget()),
          ],
        ),
      ),
      Flexible(child: SummarizedInfoWidget()),
    ]);
  }
}

class SummarizedInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<Widget> row = [];

    row.add(
      Flexible(
        child: Column(
          children: [
            ListTile(
                title: Text(
              "Humanity",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            )),
            Flexible(child: NoTitleCounterWidget(current: 2 + 3)),
          ],
        ),
      ),
    );

    return Row(children: row);
  }
}

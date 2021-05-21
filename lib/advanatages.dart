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

class SummarizedInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final noTitleRestraint = BoxConstraints(
        maxHeight: 22, minHeight: 22, maxWidth: 250, minWidth: 250);

    List<Widget> elements = [];

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
      child: NoTitleCounterWidget(current: 10),
      constraints: noTitleRestraint,
    ));
    elements.add(Container(
        child: ClickableSquareCounterWidget(current: 10, localMax: 10, max: 10),
        constraints: noTitleRestraint));

    elements.add(Text(
      "Bloodpool",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));
    elements.add(Container(
      child: ClickableSquareCounterWidget(current: 0, localMax: 10, max: 10),
      constraints: noTitleRestraint,
    ));
    elements.add(Container(
      child: ClickableSquareCounterWidget(current: 0, localMax: 10, max: 10),
      constraints: noTitleRestraint,
    ));

    return Column(
      children: elements,
      // mainAxisSize: MainAxisSize.min,
    );
    // );
  }
}

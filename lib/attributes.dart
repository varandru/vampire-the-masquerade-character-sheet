import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'defs.dart';

// Как выглядит этот виджет: Общий заголовок, под ним три колонки
// У каждой колонки есть заголовок и три атрибута
// Итого: общий AttributesSection(Widget)
// В нём AttributesColumn(Widget)
// В них Attribute(Widget)

enum AttributeColumnType { Physical, Mental, Social }

final physicalAttributesProvider = StateProvider<PhysicalAttributesColumn>(
    (ref) => PhysicalAttributesColumn());

final socialAttributesProvider =
    StateProvider<SocialAttributesColumn>((ref) => SocialAttributesColumn());

final mentalAttributesProvider =
    StateProvider<MentalAttributesColumn>((ref) => MentalAttributesColumn());

class AttributesSectionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Column(
      children: [
        Text("Attributes", style: Theme.of(context).textTheme.headline4),
        Wrap(
          children: [
            AttributesColumnWidget(AttributeColumnType.Physical),
            AttributesColumnWidget(AttributeColumnType.Social),
            AttributesColumnWidget(AttributeColumnType.Mental),
          ],
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class PhysicalAttributesColumn {
  final header = "Physical";

  var attributes = [
    Attribute(name: "Strength"),
    Attribute(name: "Dexterity"),
    Attribute(name: "Stamina")
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    Attribute(name: "Charisma"),
    Attribute(name: "Manipulation"),
    Attribute(name: "Appearance")
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    Attribute(name: "Perception"),
    Attribute(name: "Intelligence"),
    Attribute(name: "Wits")
  ];
}

class AttributesColumnWidget extends ConsumerWidget {
  AttributesColumnWidget(AttributeColumnType type) : _type = type;

  final _type;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String header = "";
    List<Attribute> attributes = [];

    switch (_type) {
      case AttributeColumnType.Physical:
        header = watch(physicalAttributesProvider).state.header;
        attributes = watch(physicalAttributesProvider).state.attributes;
        break;
      case AttributeColumnType.Mental:
        header = watch(mentalAttributesProvider).state.header;
        attributes = watch(mentalAttributesProvider).state.attributes;
        break;
      case AttributeColumnType.Social:
        header = watch(socialAttributesProvider).state.header;
        attributes = watch(socialAttributesProvider).state.attributes;
        break;
    }

    List<Widget> columns = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in attributes) {
      columns.add(AttributeWidget(attribute: attr));
    }

    // Attribute column
    return Column(
      children: columns,
      mainAxisSize: MainAxisSize.min,
    );
  }
}

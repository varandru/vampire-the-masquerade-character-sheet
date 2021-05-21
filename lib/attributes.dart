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
          alignment: WrapAlignment.center,
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
    Attribute(name: "Strength", current: 1),
    Attribute(name: "Dexterity", current: 5),
    Attribute(name: "Stamina", current: 2),
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    Attribute(name: "Charisma", current: 1),
    Attribute(name: "Manipulation", current: 1),
    Attribute(name: "Appearance", current: 4),
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    Attribute(name: "Perception", current: 1),
    Attribute(name: "Intelligence", current: 5),
    Attribute(name: "Wits", current: 4)
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

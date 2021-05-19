import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vampire_the_masquerade_character_sheet/common.dart';

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
        Expanded(
            child: Row(
          children: [
            Flexible(
              child: AttributesColumnWidget(AttributeColumnType.Physical),
              fit: FlexFit.loose,
            ),
            Flexible(
              child: AttributesColumnWidget(AttributeColumnType.Social),
              fit: FlexFit.loose,
            ),
            Flexible(
              child: AttributesColumnWidget(AttributeColumnType.Mental),
              fit: FlexFit.loose,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
        ))
      ],
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

    return ListView(
      children: column,
      padding: EdgeInsets.zero,
    );
  }
}

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

class AttributeWidget extends ConsumerWidget {
  AttributeWidget({Key? key, required Attribute attribute})
      : this.attribute = attribute,
        super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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

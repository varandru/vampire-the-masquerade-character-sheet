import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vampire_the_masquerade_character_sheet/common.dart';

// Как выглядит этот виджет: Общий заголовок, под ним три колонки
// У каждой колонки есть заголовок и три атрибута
// Итого: общий AttributesSection(Widget)
// В нём AttributesColumn(Widget)
// В них Attribute(Widget)

final physicalAttributesProvider =
    StateProvider<AttributesColumn>((ref) => AttributesColumn());

class AttributesColumn {
  final header = "Physical";

  var attributes = [
    Attribute(name: "Strength"),
    Attribute(name: "Dexterity"),
    Attribute(name: "Stamina")
  ];
}

class PhysicalAttributesColumnWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final attributeColumn = watch(physicalAttributesProvider).state;
    List<Widget> column = [
      Text(
        attributeColumn.header,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ];
    for (var attr in attributeColumn.attributes) {
      column.add(AttributeWidget(attribute: attr));
    }

    return Column(
      children: column,
    );
  }
}

class Attribute {
  Attribute({required String name, int current = 1, int max = 5})
      : this.name = name,
        this.current = current,
        this.max = max;
  String name;
  int current;
  int max;
}

class AttributeWidget extends ConsumerWidget {
  AttributeWidget({Key? key, required Attribute attribute})
      : this.attribute = attribute,
        super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<Widget> row = [];
    row.add(Text("${attribute.name} ${attribute.current}/${attribute.max}"));
    for (int i = 0; i < attribute.current; i++) {
      row.add(Icon(Icons.circle));
    }
    for (int i = attribute.current; i < attribute.max; i++) {
      row.add(Icon(Icons.circle_outlined));
    }
    return Row(
      children: row,
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}

// class _AttributeState extends State<Attribute> {}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'attributes.dart';
import 'defs.dart';

// Как выглядит этот виджет: Общий заголовок, под ним три колонки
// У каждой колонки есть заголовок и три атрибута
// Итого: общий AttributesSection(Widget)
// В нём AttributesColumn(Widget)
// В них Attribute(Widget)

class AttributesSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class AttributesColumnWidget extends StatelessWidget {
  AttributesColumnWidget(AttributeColumnType this.type);

  final type;

  @override
  Widget build(BuildContext context) {
    final AttributesController ac = Get.find();
    List<Widget> columns = [
      Text(
        ac.getHeaderByType(type),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in ac.getColumnByType(type)) {
      columns.add(AttributeWidget(attribute: attr));
    }

    // Attribute column
    return Column(
      children: columns,
      mainAxisSize: MainAxisSize.min,
    );
  }
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(attribute.name),
                  children: [
                    Text(attribute.description),
                  ],
                );
              }).then((value) => null);
        },
      ),
    );
  }
}

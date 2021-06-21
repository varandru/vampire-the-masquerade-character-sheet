// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'attributes.dart';
// import 'common_widget.dart';

// // Как выглядит этот виджет: Общий заголовок, под ним три колонки
// // У каждой колонки есть заголовок и три атрибута
// // Итого: общий AttributesSection(Widget)
// // В нём AttributesColumn(Widget)
// // В них Attribute(Widget)

// class AttributesSectionWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("Attributes", style: Theme.of(context).textTheme.headline4),
//         Wrap(
//           alignment: WrapAlignment.center,
//           children: [
//             AttributesColumnWidget(AttributeColumnType.Physical),
//             AttributesColumnWidget(AttributeColumnType.Social),
//             AttributesColumnWidget(AttributeColumnType.Mental),
//           ],
//         ),
//       ],
//       mainAxisSize: MainAxisSize.min,
//     );
//   }
// }

// class AttributesColumnWidget extends StatelessWidget {
//   AttributesColumnWidget(AttributeColumnType this.type);

//   final type;

//   @override
//   Widget build(BuildContext context) {
//     final AttributesController ac = Get.find();
//     return ComplexAbilityColumnWidget(ac.getColumnByType(type));
//   }
// }

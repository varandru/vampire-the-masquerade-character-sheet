import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'abilities.dart';
import 'common_widget.dart';

class AbilitiesSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Abilities", style: Theme.of(context).textTheme.headline4),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            AbilitiesColumnWidget(AbilityColumnType.Talents),
            AbilitiesColumnWidget(AbilityColumnType.Skills),
            AbilitiesColumnWidget(AbilityColumnType.Knowledges),
          ],
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class AbilitiesColumnWidget extends StatelessWidget {
  AbilitiesColumnWidget(AbilityColumnType this.type);

  final type;

  @override
  Widget build(BuildContext context) {
    final AbilitiesController ac = Get.find();

    List<Widget> column = [
      Text(
        ac.getHeaderByType(type),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in ac.getColumnByType(type)) {
      column.add(ComplexAbilityWidget(attribute: attr));
    }

    return Column(
      children: column,
      mainAxisSize: MainAxisSize.min,
    );
  }
}

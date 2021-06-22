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

class AbilitiesColumnWidget extends ComplexAbilityColumnWidget {
  AbilitiesColumnWidget(AbilityColumnType this.type) {
    AbilitiesController ac = Get.find();
    super.name = ac.getColumnByType(type).name;
    super.values = ac.getColumnByType(type).values;
    super.editValue = ac.getColumnByType(type).editValue;
    super.deleteValue = ac.getColumnByType(type).deleteValue;
  }

  final type;
}

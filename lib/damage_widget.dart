import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/damage.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

class DamageWidget extends StatelessWidget {
  DamageWidget(int level, DamageDot dot)
      : _damageDot = dot,
        level = level;
  final DamageDot _damageDot;
  final int level;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(_damageDot.name),
        trailing: DropdownButton(
          items: [
            DropdownMenuItem<DamageType>(
              child: Icon(Icons.circle_outlined),
              value: DamageType.None,
            ),
            DropdownMenuItem<DamageType>(
              child: Icon(Icons.not_interested),
              value: DamageType.Lethal,
            ),
            DropdownMenuItem<DamageType>(
              child: Icon(Icons.highlight_off),
              value: DamageType.Aggravated,
            ),
          ],
          value: _damageDot.type,
          onChanged: (DamageType? type) {
            if (type != null) {
              Get.find<DamageController>().switchType(_damageDot.type, type);
            }
          },
        ),
      );
}

class DamageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Get.find<DamageController>()
            .fromDatabase(Get.find<DatabaseController>().database),
        builder: (context, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? CircularProgressIndicator()
                : Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: Get.find<DamageController>().damage.length + 1,
                    itemBuilder: (context, index) => index == 0
                        ? Text(
                            'Damage',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        : DamageWidget(index - 1,
                            Get.find<DamageController>().damage[index - 1]!))));
  }
}

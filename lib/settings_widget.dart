import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/database.dart';

class Settings extends GetxController {
  var query = 'db query here'.obs;
  var exception = ''.obs;
  var results = RxList<Map<String, Object?>>();
}

TableRow tableRow(Map<String, Object?> input) => TableRow(
    children: List.generate(input.length,
        (index) => Text(input.values.elementAt(index)?.toString() ?? '')));

class SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Settings settings = Get.find();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('data'),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: TextField(
            controller: TextEditingController()..text = settings.query.value,
            onChanged: (value) => settings.query.value = value,
          )),
          TextButton(
              onPressed: () async {
                try {
                  settings.results.value = await Get.find<DatabaseController>()
                      .database
                      .rawQuery(settings.query.value);
                } catch (e) {
                  settings.exception.value = e.toString();
                }
              },
              child: Text('Execute')),
        ]),
        Obx(() => Text(settings.exception.value)),
        Obx(() => settings.results.length == 0
            ? Table()
            : Table(
                children: List.generate(
                    settings.results.length + 1,
                    (index) => index == 0
                        ? TableRow(
                            children: List.generate(
                                settings.results[0].keys.length,
                                (index) => Text(settings.results[0].keys
                                    .elementAt(index)
                                    .toString())))
                        : tableRow(settings.results[index - 1])),
              )),
      ],
    );
  }
}

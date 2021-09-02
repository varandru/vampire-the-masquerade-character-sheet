import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_info.dart';

const int minGeneration = 8;
const int maxGeneration = 14;

class CommonCharacterInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0.0,
      runSpacing: 0.0,
      children: [
        MainInfoWidget(MainInfoFieldType.CharacterName),
        MainInfoWidget(MainInfoFieldType.PlayerName),
        MainInfoWidget(MainInfoFieldType.Chronicle),
        MainInfoWidget(MainInfoFieldType.Nature),
        MainInfoWidget(MainInfoFieldType.Demeanor),
        MainInfoWidget(MainInfoFieldType.Concept),
        MainInfoWidget(MainInfoFieldType.Clan),
        IntrinsicWidth(
            child: Obx(() => DropdownButtonFormField(
                  items: List.generate(
                      maxGeneration - minGeneration + 1,
                      (index) => DropdownMenuItem<int>(
                            child: Text(
                              "${index + minGeneration}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            value: index + minGeneration,
                          )),
                  decoration: InputDecoration(
                      labelText: Get.find<MainInfoController>()
                          .getFieldNameByType(MainInfoFieldType.Generation)),
                  value: Get.find<MainInfoController>().generation,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null && value is int)
                      Get.find<MainInfoController>().setGeneration(value);
                  },
                  isDense: false,
                ))),
        MainInfoWidget(MainInfoFieldType.Sire),
      ],
    );
  }
}

class MainInfoWidget extends StatelessWidget {
  MainInfoWidget(this._type);

  final MainInfoFieldType _type;

  @override
  Widget build(BuildContext context) {
    final MainInfoController controller = Get.find();
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextButton(
        child: IntrinsicWidth(
            child: Obx(
          () => TextFormField(
            controller: TextEditingController()
              ..text = "${controller.getByType(_type)}",
            decoration: InputDecoration(
                labelText: controller.getFieldNameByType(_type)),
            style: Theme.of(context).textTheme.headline6,
            enabled: false,
            readOnly: true,
          ),
        )),
        onPressed: () async {
          TextEditingController _controller =
              TextEditingController(text: "${controller.getByType(_type)}");
          var string = await Get.dialog<String?>(AlertDialog(
            content: TextField(
              controller: _controller,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back(result: _controller.text);
                  },
                  child: Text("Ok")),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel")),
            ],
          ));
          if (string != null) {
            controller.setByType(_type, string);
          }
        },
      ),
    );
  }
}

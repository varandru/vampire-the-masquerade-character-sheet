import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_info.dart';

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
        MainInfoWidget(MainInfoFieldType.Generation),
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
    final MainInfo controller = Get.find();
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextButton(
        child: Obx(
          () => Text(
            "${controller.getByType(_type)}",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
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

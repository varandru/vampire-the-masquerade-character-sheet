import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_widget.dart';
import 'drawer_menu.dart';
import 'merits_and_flaws.dart';

class MeritWidget extends StatelessWidget {
  MeritWidget(this._merit, {required this.index, this.isMerit = true});

  final Merit _merit;
  final int index;
  final bool isMerit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_merit.name),
      subtitle: Text(meritName(_merit.type)),
      trailing: Text(_merit.cost.toString()),
      onTap: () {
        Get.dialog(MeritPopUp(
          _merit,
          index: index,
          isMerit: isMerit,
        ));
      },
    );
  }
}

class MeritsAndFlawsSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeritsAndFlawsController mafc = Get.find();

    int meritSum = 0;
    for (var merit in mafc.merits) {
      meritSum += merit.cost;
    }

    int flawSum = 0;
    for (var flaw in mafc.flaws) {
      flawSum += flaw.cost;
    }

    return Column(
      children: [
        Text(
          "Merits ($meritSum)",
          style: Theme.of(context).textTheme.headline4,
        ),
        Flexible(
          child: Obx(() => ListView.builder(
                itemBuilder: (context, i) => Obx(() => MeritWidget(
                      mafc.merits[i],
                      index: i,
                      isMerit: true,
                    )),
                itemCount: mafc.merits.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )),
        ),
        Text(
          "Flaws ($flawSum)",
          style: Theme.of(context).textTheme.headline4,
        ),
        Flexible(
          child: Obx(() => ListView.builder(
                itemBuilder: (context, i) => Obx(() => MeritWidget(
                      mafc.flaws[i],
                      index: i,
                      isMerit: false,
                    )),
                itemCount: mafc.flaws.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

/// For info
class MeritPopUp extends Dialog {
  MeritPopUp(this.merit, {required this.index, this.isMerit = true});

  final Merit merit;
  final int index;

  /// or is flaw
  final bool isMerit;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        merit.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5,
      ),
      children: [
        Text(
          "${meritName(merit.type)}, ${merit.cost} points",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(merit.description),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  final ca = await Get.dialog<Merit>(MeritDialog(
                    name: 'Edit ${merit.name}',
                    merit: merit,
                  ));
                  if (ca != null) {
                    final MeritsAndFlawsController cmaf = Get.find();
                    if (isMerit)
                      cmaf.merits[index] = ca;
                    else
                      cmaf.flaws[index] = ca;
                  }
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  bool? delete =
                      await Get.dialog<bool>(DeleteDialog(name: merit.name));
                  if (delete != null && delete == true) {
                    final MeritsAndFlawsController cmaf = Get.find();
                    if (isMerit)
                      cmaf.merits.removeAt(index);
                    else
                      cmaf.flaws.removeAt(index);
                    Get.back();
                  }
                },
                icon: Icon(Icons.delete)),
          ],
        ),
      ],
    );
  }
}

/// For adding a new one or modifying an existing one
class MeritDialog extends Dialog {
  MeritDialog({required this.name, this.merit});

  final String name;
  final Merit? merit;

  @override
  Widget build(BuildContext context) {
    var m = (merit != null)
        ? merit!.obs
        : Merit(name: name, type: MeritType.Physical).obs;

    return SimpleDialog(
      title: Text(name),
      children: [
        Row(children: [
          Text("Name: "),
          Expanded(
              child: TextField(
            controller: TextEditingController()..text = m.value.name,
          ))
        ]),
        Row(children: [
          Text("Type: "),
          Obx(
            () => DropdownButton(
                items: [
                  DropdownMenuItem<MeritType>(
                      child: Text("Physical"), value: MeritType.Physical),
                  DropdownMenuItem<MeritType>(
                      child: Text("Mental"), value: MeritType.Mental),
                  DropdownMenuItem<MeritType>(
                      child: Text("Social"), value: MeritType.Social),
                  DropdownMenuItem<MeritType>(
                      child: Text("Supernatural"),
                      value: MeritType.Supernatural),
                ],
                value: m.value.type,
                onChanged: (MeritType? value) =>
                    m.update((val) => val!.type = value ?? val.type)),
          )
        ]),
        Row(children: [
          Text("Cost: "),
          Expanded(
              child: Obx(() => Slider(
                    value: m.value.cost.toDouble(),
                    min: 1.0,
                    max: 7.0,
                    divisions: 7,
                    label: m.value.cost.toString(),
                    onChanged: (double value) =>
                        m.update((val) => val?.cost = value.round()),
                  ))),
        ]),
        Row(children: [
          Text("Description: "),
          Expanded(
            child: TextField(
              controller: TextEditingController()..text = m.value.description,
              onChanged: (value) => m.update((val) {
                val?.description = value;
              }),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ]),
        Row(
          children: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(result: null),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (m.value.name.isNotEmpty)
                  Get.back(result: m.value);
                else
                  Get.back(result: null);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ],
    );
  }
}

class AddMeritButton extends CommonSpeedDialChild {
  AddMeritButton()
      : super(
          child: Icon(Icons.sentiment_very_satisfied_outlined),
          backgroundColor: Colors.lightGreen.shade300,
          label: "Add custom merit",
          onTap: () async {
            final ca = await Get.dialog<Merit>(MeritDialog(name: 'New Merit'));
            if (ca != null) {
              MeritsAndFlawsController ac = Get.find();
              ac.merits.add(ca);
            }
          },
        );
}

class AddFlawButton extends CommonSpeedDialChild {
  AddFlawButton()
      : super(
          child: Icon(Icons.sentiment_very_dissatisfied_outlined),
          backgroundColor: Colors.pink.shade300,
          label: "Add custom flaw",
          onTap: () async {
            final ca = await Get.dialog<Merit>(MeritDialog(name: 'New Flaw'));
            if (ca != null) {
              MeritsAndFlawsController ac = Get.find();
              ac.flaws.add(ca);
            }
          },
        );
}

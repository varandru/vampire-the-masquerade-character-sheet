import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'common_logic.dart';
import 'merits_and_flaws.dart';

class MeritWidget extends StatelessWidget {
  MeritWidget(this._merit);

  final Merit _merit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_merit.name),
      subtitle: Text(meritName(_merit.type)),
      trailing: Text(_merit.cost.toString()),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(_merit.name),
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(_merit.description),
                ],
              );
            }).then((value) => null);
      },
    );
  }
}

class MeritsAndFlawsSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeritsAndFlawsController mafc = Get.find();

    // final merits = [
    //   MeritWidget(
    //     Merit(
    //       name: "Computer Aptitude",
    //       type: MeritType.Mental,
    //       cost: 2,
    //       description:
    //           "You are familiar with and talented in the uses of computer equipment. Other Kindred may not understand computers, but to you they are intuitive. All rolls involving computers are at -2 difficulty for you.",
    //     ),
    //   ),
    // ];

    int meritSum = 0;
    for (var merit in mafc.merits) {
      meritSum += merit.cost;
    }

    // final flaws = [
    //   MeritWidget(
    //     Merit(
    //       name: "Bad Sight (1 pt.)",
    //       type: MeritType.Physical,
    //       cost: 1,
    //       description:
    //           "Your sight is defective. The difficulties of any die rolls involving the use of your eyesight are increased by two. As a one-point Flaw, this condition can be corrected with glasses or contacts.",
    //     ),
    //   ),
    // ];

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
          child: ListView.builder(
            itemBuilder: (context, i) => Obx(() => MeritWidget(mafc.merits[i])),
            itemCount: mafc.merits.length,
            shrinkWrap: true,
          ),
        ),
        Text(
          "Flaws ($flawSum)",
          style: Theme.of(context).textTheme.headline4,
        ),
        Flexible(
          child: ListView.builder(
            itemBuilder: (context, i) => Obx(() => MeritWidget(mafc.flaws[i])),
            itemCount: mafc.flaws.length,
            shrinkWrap: true,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class MeritDialog extends Dialog {
  MeritDialog({required this.name, this.merit});

  final String name;
  final Merit? merit;

  @override
  Widget build(BuildContext context) {
    var m = (merit != null) ? merit!.obs : Merit(name: name).obs;

    return SimpleDialog(
      title: Text(name),
    );
  }
}

// class AddKnowledgeButton extends SpeedDialChild {
//   AddKnowledgeButton(BuildContext context)
//       : super(
//           child: Icon(Icons.menu_book),
//           backgroundColor: Colors.blue.shade300,
//           label: "Add custom knowledge",
//           labelBackgroundColor: Theme.of(context).colorScheme.surface,
//           onTap: () async {
//             final ca = await Get.dialog<ComplexAbility>(
//                 ComplexAbilityDialog(name: 'New Knowledge'));
//             if (ca != null) {
//               AbilitiesController ac = Get.find();
//               ac.knowledges.add(ca);
//             }
//           },
//         );
// }

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/xp.dart';

class XpSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final XPController xpc = Get.find();

    return Obx(
      () => ListView.builder(
        itemBuilder: (context, i) {
          if (i == 0) {
            return Obx(() => Text(
                  "Total: ${xpc.xpTotal.value}, spent: ${xpc.xpSpent.value}, left: ${xpc.xpTotal.value - xpc.xpSpent.value}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ));
          } else {
            var logEntry = xpc.log[i - 1];
            if (logEntry is XpEntryNewAbility)
              return XpEntryNewAbilityWidget(logEntry);
            return Obx(() => Text("${xpc.log[i - 1].description}"));
          }
        },
        itemCount: xpc.log.length + 1,
      ),
    );
  }
}

class XpEntryNewAbilityWidget extends StatelessWidget {
  XpEntryNewAbilityWidget(this.ability);

  final XpEntryNewAbility ability;

  @override
  Widget build(BuildContext context) {
    final ability = this.ability.obs;

    return ListTile(
      leading: Icon(
        Icons.arrow_circle_up,
        color: Colors.red,
      ),
      title: Obx(() => Text(ability.value.name)),
      subtitle: Obx(() => Text(ability.value.description)),
      trailing: Obx(() => Text(
            ability.value.cost.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          )),
      onTap: () async {
        var ca = await Get.dialog<XpEntryNewAbility>(XpEntryNewAbilityDialog(
          entryNewAbility: ability.value,
        ));
        if (ca != null) {
          final XPController xpc = Get.find();
          xpc.xpSpent += ca.cost - ability.value.cost;
          ability.update((val) => val?.copy(ca));
        }
      },
    );
  }
}

class XpEntryNewAbilityDialog extends Dialog {
  XpEntryNewAbilityDialog({this.entryNewAbility});

  final XpEntryNewAbility? entryNewAbility;

  @override
  Widget build(BuildContext context) {
    var entry = (entryNewAbility ??
            XpEntryNewAbility(cost: 0, name: "", description: ""))
        .obs;

    return SimpleDialog(
      title: entryNewAbility == null
          ? Text("Spend XP on a new ability")
          : Obx(() => Text("Edit ${entry.value.name}")),
      children: [
        // name
        TextField(
          controller: TextEditingController()..text = entry.value.name,
          onChanged: (value) => entry.update((val) => val?.name = value),
          decoration: InputDecoration(hintText: "What you spent XP on"),
        ),
        // cost
        TextField(
          controller: TextEditingController()
            ..text = entry.value.cost.toString(),
          onChanged: (value) =>
              entry.update((val) => val?.cost = int.parse(value)),
          keyboardType: TextInputType.number,
        ),
        // description
        TextField(
          controller: TextEditingController()..text = entry.value.description,
          onChanged: (value) => entry.update((val) => val?.description = value),
          decoration:
              InputDecoration(hintText: "(Optional) Additional information"),
        ),
        Row(
          children: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(result: null),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (entry.value.name.isNotEmpty && entry.value.cost != 0)
                  Get.back(result: entry.value);
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

class XpEntryNewAbilityButton extends SpeedDialChild {
  XpEntryNewAbilityButton(BuildContext context)
      : super(
          child: Icon(Icons.arrow_circle_up),
          backgroundColor: Colors.red.shade300,
          label: "Spend XP on an ability",
          labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            final ca =
                await Get.dialog<XpEntryNewAbility>(XpEntryNewAbilityDialog());
            if (ca != null) {
              XPController xpc = Get.find();
              xpc.xpSpent.value += ca.cost;
              xpc.log.add(ca);
            }
          },
        );
}

class XpEntryUpgradedAbilityWidget extends StatelessWidget {
  XpEntryUpgradedAbilityWidget(this.ability);

  final XpEntryUpgradedAbility ability;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.upgrade,
        color: Colors.red,
      ),
      title: Text(
          "${ability.description}: ${ability.oldLevel} -> ${ability.newLevel}"),
      trailing: Text(ability.cost.toString()),
    );
  }
}

class XpEntryGainedWidget extends StatelessWidget {
  XpEntryGainedWidget(this.ability);

  final XpEntryGained ability;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.add_circle_outline,
        color: Colors.green,
      ),
      title: Text(ability.description),
      trailing: Text(ability.gained.toString()),
    );
  }
}

class AddXpEntryGainedButton extends SpeedDialChild {
  AddXpEntryGainedButton(BuildContext context)
      : super(
          child: Icon(Icons.gesture),
          backgroundColor: Colors.blue.shade300,
          label: "Log XP gained",
          labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            // final ca = await Get.dialog<Ritual>(RitualDialog(null));
            // if (ca != null) {
            //   RitualController bc = Get.find();
            //   bc.rituals.add(ca);
            // }
          },
        );
}

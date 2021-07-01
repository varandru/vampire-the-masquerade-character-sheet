import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/xp.dart';

class XpSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final XPController xpc = Get.find();

    return Column(
      children: [
        Obx(() => Text(
              "Total: ${xpc.xpTotal.value}, spent: ${xpc.xpSpent.value}, left: ${xpc.xpTotal.value - xpc.xpSpent.value}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            )),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, i) {
                var logEntry = xpc.log[i];
                if (logEntry is XpEntryNewAbility)
                  return XpEntryNewAbilityWidget(logEntry);
                else if (logEntry is XpEntryUpgradedAbility)
                  return XpEntryUpgradedAbilityWidget(logEntry);
                else if (logEntry is XpEntryGained)
                  return XpEntryGainedWidget(logEntry);
                return Obx(() => Text("${xpc.log[i - 1].description}"));
              },
              itemCount: xpc.log.length,
              primary: true,
            ),
          ),
        ),
      ],
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
        Icons.add_circle_outline,
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
          xpc.xpSpent.value += ca.cost - ability.value.cost;
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
          decoration: InputDecoration(
              hintText: "What you spent XP on", labelText: "Name"),
        ),
        // cost
        TextFormField(
          controller: TextEditingController()
            ..text = entry.value.cost.toString(),
          onChanged: (value) => entry.update((val) {
            var result = int.tryParse(value);
            if (result != null) val?.cost = result;
          }),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => (value != null &&
                  value.isNumericOnly &&
                  int.tryParse(value) != null &&
                  int.tryParse(value)! > 0)
              ? null
              : "This should be a number",
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "XP cost"),
        ),
        // description
        TextField(
          controller: TextEditingController()..text = entry.value.description,
          onChanged: (value) => entry.update((val) => val?.description = value),
          decoration: InputDecoration(
              hintText: "(Optional) Additional information",
              labelText: "Description"),
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
  XpEntryNewAbilityButton()
      : super(
          child: Icon(Icons.add_circle_outline),
          backgroundColor: Colors.red.shade300,
          label: "Spend XP on an ability",
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
    final entry = ability.obs;

    return ListTile(
      leading: Icon(
        Icons.arrow_circle_up,
        color: Colors.red,
      ),
      title: Text(
          "${entry.value.name}: ${entry.value.oldLevel} -> ${entry.value.newLevel}"),
      trailing: Text(
        entry.value.cost.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () async {
        var ca = await Get.dialog<XpEntryUpgradedAbility>(
            XpEntryUpgradedAbilityDialog(
          entryUpgradedAbility: entry.value,
        ));
        if (ca != null) {
          final XPController xpc = Get.find();
          xpc.xpSpent.value += ca.cost - entry.value.cost;
          entry.update((val) => val?.copy(ca));
        }
      },
    );
  }
}

class XpEntryUpgradedAbilityDialog extends Dialog {
  XpEntryUpgradedAbilityDialog({this.entryUpgradedAbility});

  final XpEntryUpgradedAbility? entryUpgradedAbility;

  @override
  Widget build(BuildContext context) {
    var entry = (entryUpgradedAbility ??
            XpEntryUpgradedAbility(
                cost: 0, name: "", description: "", oldLevel: 1, newLevel: 1))
        .obs;

    return SimpleDialog(
      title: entryUpgradedAbility == null
          ? Text("Spend XP on a new ability")
          : Obx(() => Text("Edit ${entry.value.name}")),
      children: [
        // name
        TextField(
          controller: TextEditingController()..text = entry.value.name,
          onChanged: (value) => entry.update((val) => val?.name = value),
          decoration: InputDecoration(
              hintText: "What you spent XP on", labelText: "Name"),
        ),
        // old and new level go here
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: TextEditingController()
                  ..text = entry.value.oldLevel.toString(),
                onChanged: (value) => entry.update((val) {
                  var result = int.tryParse(value);
                  if (result != null) val?.oldLevel = result;
                }),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null &&
                        value.isNumericOnly &&
                        int.tryParse(value) != null &&
                        int.tryParse(value)! > 0)
                    ? null
                    : "This should be a number",
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Old level"),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: TextEditingController()
                  ..text = entry.value.newLevel.toString(),
                onChanged: (value) => entry.update((val) {
                  var result = int.tryParse(value);
                  if (result != null) val?.newLevel = result;
                }),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null &&
                        value.isNumericOnly &&
                        int.tryParse(value) != null &&
                        int.tryParse(value)! > 0)
                    ? null
                    : "This should be a number",
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "New level"),
              ),
            ),
          ],
        ),
        // cost
        TextFormField(
          controller: TextEditingController()
            ..text = entry.value.cost.toString(),
          onChanged: (value) => entry.update((val) {
            var result = int.tryParse(value);
            if (result != null) val?.cost = result;
          }),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => (value != null &&
                  value.isNumericOnly &&
                  int.tryParse(value) != null &&
                  int.tryParse(value)! > 0)
              ? null
              : "This should be a number",
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "XP cost"),
        ),
        // description
        TextField(
          controller: TextEditingController()..text = entry.value.description,
          onChanged: (value) => entry.update((val) => val?.description = value),
          decoration: InputDecoration(
              hintText: "(Optional) Additional information",
              labelText: "Description"),
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

class XpEntryUpgradedAbilityButton extends SpeedDialChild {
  XpEntryUpgradedAbilityButton()
      : super(
          child: Icon(Icons.arrow_circle_up),
          backgroundColor: Colors.red.shade300,
          label: "Spend XP to improve an ability",
          onTap: () async {
            final ca = await Get.dialog<XpEntryUpgradedAbility>(
                XpEntryUpgradedAbilityDialog());
            if (ca != null) {
              XPController xpc = Get.find();
              xpc.xpSpent.value += ca.cost;
              xpc.log.add(ca);
            }
          },
        );
}

class XpEntryGainedWidget extends StatelessWidget {
  XpEntryGainedWidget(this.ability);

  final XpEntryGained ability;

  @override
  Widget build(BuildContext context) {
    final entry = ability.obs;
    return ListTile(
      leading: Icon(
        Icons.add_circle_outline,
        color: Colors.green,
      ),
      title: Text(entry.value.description),
      trailing: Text(
        entry.value.gained.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () async {
        var ca = await Get.dialog<XpEntryGained>(XpEntryGainedDialog(
          entryGained: entry.value,
        ));
        if (ca != null) {
          final XPController xpc = Get.find();
          xpc.xpTotal.value += ca.gained - entry.value.gained;
          entry.update((val) => val?.copy(ca));
        }
      },
    );
  }
}

class XpEntryGainedDialog extends Dialog {
  XpEntryGainedDialog({this.entryGained});

  final XpEntryGained? entryGained;

  @override
  Widget build(BuildContext context) {
    var entry = (entryGained ?? XpEntryGained(gained: 0, description: "")).obs;

    return SimpleDialog(
      title: entryGained == null ? Text("Gain XP") : Text("Edit XP gain"),
      children: [
        // cost
        TextFormField(
          controller: TextEditingController()
            ..text = entry.value.gained.toString(),
          onChanged: (value) => entry.update((val) {
            var result = int.tryParse(value);
            if (result != null) val?.gained = result;
          }),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => (value != null &&
                  value.isNumericOnly &&
                  int.tryParse(value) != null &&
                  int.tryParse(value)! > 0)
              ? null
              : "This should be a number",
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "XP gained"),
        ),
        // description
        TextField(
          controller: TextEditingController()..text = entry.value.description,
          onChanged: (value) => entry.update((val) => val?.description = value),
          decoration: InputDecoration(
              hintText: "(Optional) When did you gain the experience?",
              labelText: "Description"),
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
                if (entry.value.gained > 0)
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

class AddXpEntryGainedButton extends SpeedDialChild {
  AddXpEntryGainedButton()
      : super(
          child: Icon(Icons.add_circle_outline),
          backgroundColor: Colors.green.shade300,
          label: "Log XP gained",
          onTap: () async {
            final ca = await Get.dialog<XpEntryGained>(XpEntryGainedDialog());
            if (ca != null) {
              XPController xpc = Get.find();
              xpc.xpTotal.value += ca.gained;
              xpc.log.add(ca);
            }
          },
        );
}

class RecalculateXpButton extends IconButton {
  RecalculateXpButton()
      : super(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final XPController xpc = Get.find();
              xpc.calculateXp();
            });
}

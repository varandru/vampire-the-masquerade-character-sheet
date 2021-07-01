import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_logic.dart';

List<Widget> makeIconRow(
    int current, int max, IconData filled, IconData empty) {
  List<Widget> row = [];
  for (int i = 0; i < current; i++) {
    row.add(Icon(filled, size: 20));
  }
  for (int i = current; i < max; i++) {
    row.add(Icon(empty, size: 20));
  }
  return row;
}

class NoTitleCounterWidget extends StatelessWidget {
  NoTitleCounterWidget({int current = 0, int max = 10})
      : _current = current,
        _max = max;

  final _current;
  final _max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          makeIconRow(_current, _max, Icons.circle, Icons.circle_outlined),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

/// Displays attributes, abilities and virtues.
/// Anything that conforms to ComplexAbility structure, basically
class ComplexAbilityWidget extends StatelessWidget {
  ComplexAbilityWidget({
    Key? key,
    required this.attribute,
    required this.updateCallback,
    required this.deleteCallback,
    this.index = 0,
  }) : super(key: key);

  final ComplexAbility attribute;
  final int index;
  late final Function(ComplexAbility ability, ComplexAbility old)
      updateCallback;
  late final Function(ComplexAbility ability) deleteCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = makeIconRow(
        attribute.current, attribute.max, Icons.circle, Icons.circle_outlined);
    final header = Text(
      attribute.name,
      overflow: TextOverflow.fade,
      softWrap: false,
    );

    return ListTile(
      title: header,
      subtitle: Text(attribute.specialization),
      trailing: Row(
        children: row,
        mainAxisSize: MainAxisSize.min,
      ),
      onTap: () {
        Get.dialog<void>(ComplexAbilityPopup(attribute,
            updateCallback: updateCallback,
            deleteCallback: deleteCallback,
            textTheme: Theme.of(context).textTheme));
      },
    );
  }
}

class ComplexAbilityColumnWidget extends StatelessWidget {
  ComplexAbilityColumnWidget();

  late final RxString name;
  late final RxList<ComplexAbility> values;
  late final Function(ComplexAbility ability, ComplexAbility old) editValue;
  late final Function(ComplexAbility ability) deleteValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Obx(
        () => ListView.builder(
          itemBuilder: (context, i) {
            if (i == 0)
              return Text(
                name.value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              );
            else
              return Obx(() => ComplexAbilityWidget(
                  attribute: values[i - 1],
                  index: i - 1,
                  updateCallback: editValue,
                  deleteCallback: deleteValue));
          },
          itemCount: values.length + 1,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

class ComplexAbilityPopup extends Dialog {
  ComplexAbilityPopup(this.attribute,
      {required this.updateCallback,
      required this.deleteCallback,
      this.index = 0,
      required this.textTheme});

  final ComplexAbility attribute;
  final int index;
  late final Function(ComplexAbility ability, ComplexAbility old)
      updateCallback;
  late final Function(ComplexAbility ability) deleteCallback;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.addIf(attribute.specialization.isNotEmpty,
        Text(attribute.specialization, style: textTheme.headline5));

    children.addIf(attribute.description.isNotEmpty,
        Text("Description:", style: textTheme.headline6));
    children.addIf(
        attribute.description.isNotEmpty, Text(attribute.description));

    if (attribute.isDeletable) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () async {
                final ca =
                    await Get.dialog<ComplexAbility>(ComplexAbilityDialog(
                  name: 'Edit ${attribute.name}',
                  ability: attribute,
                ));
                if (ca != null) {
                  updateCallback(ca, attribute);
                  Get.back();
                }
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                bool? delete =
                    await Get.dialog<bool>(DeleteDialog(name: attribute.name));
                if (delete != null && delete == true) {
                  deleteCallback(attribute);
                  Get.back();
                }
              },
              icon: Icon(Icons.delete)),
        ],
      ));
    } else {
      children.add(
        Center(
          child: IconButton(
              onPressed: () async {
                final ca =
                    await Get.dialog<ComplexAbility>(ComplexAbilityDialog(
                  name: 'Edit ${attribute.name}',
                  ability: attribute,
                ));
                if (ca != null) {
                  updateCallback(ca, attribute);
                  Get.back();
                }
              },
              icon: Icon(Icons.edit)),
        ),
      );
    }
    return SimpleDialog(
      title: Text(
        attribute.name,
        textAlign: TextAlign.center,
        style: textTheme.headline4,
      ),
      children: children,
    );
  }
}

class ComplexAbilityDialog extends Dialog {
  ComplexAbilityDialog({
    this.ability,
    this.name = 'New Ability',
    this.hasSpecializations = true,
  });

  final String name;
  final ComplexAbility? ability;
  final bool hasSpecializations;
  // final

  @override
  Widget build(BuildContext context) {
    var ca = (ability != null)
        ? ability!.obs
        : ComplexAbility(name: name, hasSpecialization: hasSpecializations).obs;

    List<Widget> children = [];
    if (ca.value.isNameEditable) {
      children.add(TextField(
        controller: TextEditingController()..text = ca.value.name,
        onChanged: (value) => ca.update(
          (val) => val?.name = value,
        ),
        decoration: InputDecoration(labelText: "Name"),
      ));
    } else {
      children.add(Text(ca.value.name));
    }

    children.add(Row(
      children: [
        Text('Current Value: '),
        IconButton(
            onPressed: () => ca.update((val) {
                  if (val != null) if (val.current > val.min) val.current--;
                }),
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )),
        Obx(() => Text("${ca.value.current}")),
        IconButton(
            onPressed: () => ca.update((val) {
                  if (val != null) if (val.current < val.max) val.current++;
                }),
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.green,
            )),
      ],
    ));

    children.addIf(
        ca.value.hasSpecialization,
        TextField(
          controller: TextEditingController()..text = ca.value.specialization,
          onChanged: (value) => ca.update((val) {
            val?.specialization = value;
          }),
          decoration: InputDecoration(labelText: "Specialization"),
        ));

    children.add(TextField(
      controller: TextEditingController()..text = ca.value.description,
      onChanged: (value) => ca.update((val) {
        val?.description = value;
      }),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(labelText: "Description"),
    ));

    children.add(Row(
      children: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(result: null),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (ca.value.name.isNotEmpty)
              Get.back(result: ca.value);
            else
              Get.back(result: null);
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    ));

    return SimpleDialog(
      title: Text(name),
      children: children,
    );
  }
}

class DeleteDialog extends Dialog {
  DeleteDialog({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Delete $name?"),
      children: [
        TextButton(onPressed: () => Get.back(result: true), child: Text("Ok")),
        TextButton(
            onPressed: () => Get.back(result: false), child: Text("Cancel")),
      ],
    );
  }
}

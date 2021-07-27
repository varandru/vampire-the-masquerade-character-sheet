import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import 'common_logic.dart';
import 'database.dart';

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
  NoTitleCounterWidget(
      {int current = 0,
      int max = 10,
      MainAxisAlignment alignment = MainAxisAlignment.spaceEvenly})
      : _current = current,
        _max = max,
        _alignment = alignment;

  final _current;
  final _max;
  final MainAxisAlignment _alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          makeIconRow(_current, _max, Icons.circle, Icons.circle_outlined),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _alignment,
    );
  }
}

/// Displays attributes, abilities and virtues.
/// Anything that conforms to ComplexAbility structure, basically
class ComplexAbilityWidget extends StatelessWidget {
  ComplexAbilityWidget({
    Key? key,
    required this.attribute,
    required this.description,
    required this.updateCallback,
    required this.deleteCallback,
    this.index = 0,
  }) : super(key: key);

  final ComplexAbility attribute;
  final int index;
  final ComplexAbilityEntryDatabaseDescription description;
  late final Function(ComplexAbility ability, ComplexAbility old)
      updateCallback;
  late final Function(ComplexAbility ability) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        attribute.name,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      subtitle: Text(attribute.specialization),
      trailing:
          NoTitleCounterWidget(current: attribute.current, max: attribute.max),
      onTap: () async {
        var result = await Get.find<DatabaseController>().database.query(
            description.tableName,
            where: 'id = ?',
            whereArgs: [attribute.id]);

        ComplexAbilityEntry entry = ComplexAbilityEntry(
            name: result[0]['name'] as String,
            description: result[0]['description'] as String?);

        Get.dialog<void>(
            ComplexAbilityPopup(attribute, entry, updateCallback: (a1, a2, e) {
          updateCallback(a1, a2);

          /// Database entry update
          Get.find<DatabaseController>()
              .addOrUpdateComplexAbility(a1, e, description);
        }, deleteCallback: (ability) {
          deleteCallback(ability);
          Get.find<DatabaseController>().database.delete(
              description.playerLinkTable,
              where: 'player_id = ? and ${description.fkName} = ?',
              whereArgs: [
                Get.find<DatabaseController>().characterId.value,
                ability.id
              ]);
        }, textTheme: Theme.of(context).textTheme));
      },
    );
  }
}

class ComplexAbilityColumnWidget extends StatelessWidget {
  ComplexAbilityColumnWidget();

  late final RxString name;
  late final RxList<ComplexAbility> values;
  late final ComplexAbilityEntryDatabaseDescription description;
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
                  description: description,
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
  ComplexAbilityPopup(
    this._attribute,
    this.entry, {
    required this.updateCallback,
    required this.deleteCallback,
    required this.textTheme,
  });

  final ComplexAbility _attribute;
  final ComplexAbilityEntry entry;

  late final Function(
          ComplexAbility ability, ComplexAbility old, ComplexAbilityEntry entry)
      updateCallback;
  late final Function(ComplexAbility ability) deleteCallback;

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.addIf(_attribute.specialization.isNotEmpty,
        Text(_attribute.specialization, style: textTheme.headline5));

    if (entry.description != null) {
      children.add(Text("Description:", style: textTheme.headline6));
      children.add(MarkdownBody(
        data: entry.description!,
        shrinkWrap: true,
      ));
      children.add(Text(entry.description!));
    }

    if (_attribute.isDeletable) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () async {
                final ca =
                    await Get.dialog<ComplexAbilityPair>(ComplexAbilityDialog(
                  name: 'Edit ${_attribute.name}',
                  ability: _attribute,
                  entry: entry,
                ));
                if (ca != null) {
                  updateCallback(ca.ability, _attribute, ca.entry);
                  Get.back();
                }
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                bool? delete =
                    await Get.dialog<bool>(DeleteDialog(name: _attribute.name));
                if (delete != null && delete == true) {
                  deleteCallback(_attribute);
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
                    await Get.dialog<ComplexAbilityPair>(ComplexAbilityDialog(
                  name: 'Edit ${_attribute.name}',
                  ability: _attribute,
                ));
                if (ca != null) {
                  updateCallback(ca.ability, _attribute, ca.entry);
                  Get.back();
                }
              },
              icon: Icon(Icons.edit)),
        ),
      );
    }

    return SimpleDialog(
      title: Text(
        _attribute.name,
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
    this.entry,
    this.name = 'New Ability',
    this.hasSpecializations = true,
  });

  final String name;

  final ComplexAbility? ability;
  final ComplexAbilityEntry? entry;

  final bool hasSpecializations;

  @override
  Widget build(BuildContext context) {
    var ca = (ability != null)
        ? ability!.obs
        : ComplexAbility(
                id: null,
                txtId: "undefined",
                name: name,
                hasSpecialization: hasSpecializations)
            .obs;

    var e = (entry != null)
        ? entry!.obs
        : ComplexAbilityEntry(name: 'Undefined').obs;

    List<Widget> children = [];
    children.add(TextField(
      controller: TextEditingController()..text = ca.value.name,
      onChanged: (value) {
        ca.update(
          (val) => val?.name = value,
        );
        e.update(
          (val) => val?.name = value,
        );
      },
      decoration: InputDecoration(labelText: "Name"),
    ));

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
      controller: TextEditingController()..text = e.value.description ?? "",
      onChanged: (value) => e.update((val) {
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
            if (ca.value.name.isNotEmpty) {
              if (ca.value.txtId == 'undefined') {
                ca.value =
                    ComplexAbility.fromOther(identify(ca.value.name), ca.value);
              }

              if (e.value.description != null && e.value.description!.isEmpty)
                e.value.description = null;

              if (e.value.databaseId == null) e.value.databaseId = ca.value.id;
              if (e.value.name != ca.value.name) e.value.name = ca.value.name;

              Get.back(result: ComplexAbilityPair(ca.value, e.value));
            } else {
              Get.back(result: null);
            }
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

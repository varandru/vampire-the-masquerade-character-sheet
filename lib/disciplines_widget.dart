// A widget for a single discipline, ExpansionTile
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:vampire_the_masquerade_character_sheet/common_logic.dart';

import 'common_widget.dart';
import 'database.dart';
import 'disciplines.dart';
import 'drawer_menu.dart';

class DisciplineWidget extends StatelessWidget {
  DisciplineWidget(Discipline discipline, {required this.index})
      : _discipline = discipline;

  final Discipline _discipline;
  final int index;

  @override
  Widget build(BuildContext context) {
    final discipline = _discipline.obs;

    List<Widget> children = [];

    if (_discipline.description != null)
      children.add(Markdown(
        data: discipline.value.description!,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ));

    if (_discipline.system != null) {
      children.add(Markdown(
        data: "**System:**\n" + (discipline.value.system ?? ""),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ));
    }

    if (discipline.value.levels != null &&
        discipline.value.levels!.length > 0) {
      for (int i = 0; i < discipline.value.levels!.length; i++) {
        children.addIf(
            discipline.value.levels![i].level <= discipline.value.level,
            Obx(() => DisciplineDotWidget(
                  dot: discipline.value.levels![i],
                  index: i,
                  removeDot: (i) =>
                      discipline.update((val) => val?.removeDot(i)),
                )));
      }
    }
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final ca = await Get.dialog<Discipline>(DisciplineDialog(
                discipline.value,
                index: index,
              ));
              if (ca != null) {
                final DisciplineController dc = Get.find();
                dc.disciplines[index] = ca;
                // TODO: discipline does not get edited. Right now only level is done
                Get.find<DatabaseController>().database.update(
                    'player_disciplines', {'level': ca.level},
                    where: 'player_id = ? and discipline_id = ?',
                    whereArgs: [
                      Get.find<DatabaseController>().characterId.value,
                      ca.id
                    ]);
              }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete = await Get.dialog<bool>(
                  DeleteDialog(name: discipline.value.name));
              if (delete != null && delete == true) {
                final DisciplineController dc = Get.find();
                dc.disciplines.removeAt(index);
                Get.back();
              }
            },
            icon: Icon(Icons.delete)),
      ],
    ));

    return ExpansionTile(
      title: Text(discipline.value.name),
      trailing: Container(
        constraints:
            BoxConstraints(maxWidth: discipline.value.max.toDouble() * 20.0),
        child: NoTitleCounterWidget(
          current: discipline.value.level,
          max: discipline.value.max,
        ),
      ),
      children: children,
    );
  }
}

class DisciplinesSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DisciplineController dc = Get.find();

    return FutureBuilder(
        future: dc.fromDatabase(Get.find<DatabaseController>().database),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return CircularProgressIndicator();
          else
            return Obx(
              () => ListView.builder(
                itemBuilder: (context, i) {
                  if (i == 0)
                    return Text("Disciplines",
                        style: Theme.of(context).textTheme.headline4);
                  else if (dc.disciplines[i - 1] is Discipline)
                    return Obx(() => DisciplineWidget(
                          dc.disciplines[i - 1],
                          index: i - 1,
                        ));
                  else
                    return Placeholder();
                },
                itemCount: dc.disciplines.length + 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            );
        });
  }
}

class DisciplineDotWidget extends StatelessWidget {
  DisciplineDotWidget(
      {required DisciplineDot dot,
      required this.index,
      required this.removeDot})
      : this.d = dot;

  final DisciplineDot d;
  final int index;
  final Function(int) removeDot;

  @override
  Widget build(BuildContext context) {
    final dot = d.obs;

    return Container(
      constraints: BoxConstraints(maxWidth: 300.0),
      child: Obx(() => ListTile(
            title: Text(dot.value.name),
            trailing: Container(
              constraints:
                  BoxConstraints(maxWidth: 20.0 * dot.value.max.toDouble()),
              child: NoTitleCounterWidget(
                current: dot.value.level,
                max: dot.value.max,
              ),
            ),
            onTap: () async {
              var ca = await Get.dialog<DisciplineDot>(DisciplineDotPopup(
                dot.value,
                index: index,
                deleteDot: (index) {
                  removeDot(index);
                  Get.back();
                },
              ));
              if (ca != null) {
                dot.update((val) => val = ca);
              }
            },
          )),
    );
  }
}

/// Use this whenever you want to edit a discipline
class DisciplineDialog extends Dialog {
  DisciplineDialog(Discipline? disc, {required this.index})
      : this.disc = new Discipline(
            id: disc?.id,
            txtId: disc?.txtId ?? 'undefined',
            name: disc?.name ?? "New casting discipline",
            level: disc?.level ?? 1,
            levels: disc?.levels ?? [],
            system: disc?.system,
            description: disc?.description);

  final Discipline disc;
  final int index;

  @override
  Widget build(BuildContext context) {
    var discipline = disc.obs;

    return SimpleDialog(
      title: Text(discipline.value.name),
      children: [
        // Discipline level editor.
        TextField(
            controller: TextEditingController()..text = discipline.value.name,
            onChanged: (value) => discipline.update((val) => val?.name = value),
            keyboardType: TextInputType.multiline,
            maxLines: null),
        Row(children: [
          Text('Current Level: '),
          IconButton(
              onPressed: () => discipline.update((val) {
                    if (val != null) {
                      if (val.level > 1) val.level--;
                      val.level > 5 ? val.max = val.level : val.max = 5;
                    }
                  }),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
          Obx(() => Text("${discipline.value.level}")),
          IconButton(
              onPressed: () => discipline.update((val) {
                    if (val != null) {
                      if (val.level < 10) val.level++;
                      val.level > 5 ? val.max = val.level : val.max = 5;
                    }
                  }),
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.green,
              )),
        ], mainAxisAlignment: MainAxisAlignment.center),
        ExpansionTile(
          title: Text('Description: '),
          children: [
            TextField(
                controller: TextEditingController()
                  ..text = discipline.value.description ?? "",
                onChanged: (value) =>
                    discipline.update((val) => val?.description = value),
                keyboardType: TextInputType.multiline,
                maxLines: null),
          ],
        ),
        ExpansionTile(
          title: Text('System:'),
          children: [
            TextField(
                controller: TextEditingController()
                  ..text = discipline.value.system ?? "",
                onChanged: (value) =>
                    discipline.update((val) => val?.system = value),
                keyboardType: TextInputType.multiline,
                maxLines: null),
          ],
        ),
        Text(
          "Levels",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),

        Container(
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, i) =>
                  (i != discipline.value.levels!.length)
                      ? Obx(() => DisciplineDotWidget(
                            dot: discipline.value.levels![i],
                            index: i,
                            removeDot: (i) =>
                                discipline.update((val) => val?.removeDot(i)),
                          ))
                      : TextButton(
                          onPressed: () async {
                            var dot = await Get.dialog<DisciplineDot>(
                                DisciplineDotDialog(null));
                            if (dot != null)
                              discipline.update((val) => val?.levels!.add(dot));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline),
                              Text("Add another discipline level")
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
              itemCount: discipline.value.levels!.length + 1,
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              // )
            ),
          ),
          width: double.maxFinite,
        ),

        Row(children: [
          TextButton(
              child: Text('Cancel'), onPressed: () => Get.back(result: null)),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              if (discipline.value.name.isNotEmpty) {
                if (discipline.value.txtId == 'undefined') {
                  discipline.value = Discipline.fromOther(
                    disc.id,
                    discipline.value,
                    txtId: identify(discipline.value.name),
                  );
                }
                Get.back(result: discipline.value);
              } else {
                Get.back(result: null);
              }
            },
          )
        ], mainAxisAlignment: MainAxisAlignment.end),
      ],
    );
  }
}

/// Use this whenever you want to show info about a discipline level
class DisciplineDotPopup extends Dialog {
  DisciplineDotPopup(DisciplineDot dot,
      {required this.deleteDot, required this.index})
      : this.d = dot;

  final DisciplineDot d;
  final Function(int) deleteDot;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dot = d.obs;

    List<Widget> children = [];

    children.add(Obx(() => Row(
          children: makeIconRow(dot.value.level, dot.value.max, Icons.circle,
              Icons.circle_outlined),
          mainAxisAlignment: MainAxisAlignment.center,
        )));

    children.addIf(
        dot.value.description != null,
        ExpansionTile(
            title: Text("Description"),
            children: [Obx(() => Text(dot.value.description!))]));

    children.add(ExpansionTile(
        title: Text("System"), children: [Obx(() => Text(dot.value.system))]));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final ca = await Get.dialog<DisciplineDot>(
                  DisciplineDotDialog(dot.value));
              if (ca != null) {
                dot.update((val) => val?.copy(ca));
                // TODO: dots aren't updated in DB at all
              }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: dot.value.name));
              if (delete != null && delete == true) {
                deleteDot(index);
                Get.back();
              }
            },
            icon: Icon(Icons.delete)),
      ],
    ));

    return SimpleDialog(title: Text(dot.value.name), children: children);
  }
}

class DisciplineDotDialog extends Dialog {
  DisciplineDotDialog(DisciplineDot? dot)
      : d = new DisciplineDot(
          name: dot?.name ?? "New level",
          level: dot?.level ?? 1,
          system: dot?.system ?? "",
          max: dot?.max ?? 5,
          description: dot?.description,
        );

  final DisciplineDot d;

  @override
  Widget build(BuildContext context) {
    final dot = d.obs;

    return SimpleDialog(title: Text(dot.value.name), children: [
      TextField(
          controller: TextEditingController()..text = dot.value.name,
          onChanged: (value) => dot.update((val) => val?.name = value)),
      Row(children: [
        Text('Level: '),
        IconButton(
            onPressed: () => dot.update((val) {
                  if (val != null) {
                    if (val.level > 1) {
                      val.level--;
                      val.level > 5 ? val.max = val.level : val.max = 5;
                    }
                  }
                }),
            icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
        Obx(() => Text("${dot.value.level}")),
        IconButton(
            onPressed: () => dot.update((val) {
                  if (val != null) {
                    if (val.level < 10) {
                      val.level++;
                      val.level > 5 ? val.max = val.level : val.max = 5;
                    }
                  }
                }),
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.green,
            )),
      ], mainAxisAlignment: MainAxisAlignment.center),
      ExpansionTile(title: Text("Description"), children: [
        TextField(
            controller: TextEditingController()
              ..text = dot.value.description ?? "",
            onChanged: (value) => dot.update((val) => val?.description = value),
            keyboardType: TextInputType.multiline,
            maxLines: null)
      ]),
      ExpansionTile(title: Text("System"), children: [
        TextField(
            controller: TextEditingController()..text = dot.value.system,
            onChanged: (value) => dot.update((val) => val?.system = value),
            keyboardType: TextInputType.multiline,
            maxLines: null)
      ]),
      Row(children: [
        TextButton(
            child: Text('Cancel'), onPressed: () => Get.back(result: null)),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (dot.value.name.isNotEmpty)
              Get.back(result: dot.value);
            else
              Get.back(result: null);
          },
        )
      ], mainAxisAlignment: MainAxisAlignment.end),
    ]);
  }
}

class AddExistingDisciplineDialog extends Dialog {
  AddExistingDisciplineDialog()
      : super(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  );
                case ConnectionState.done:
                  if (snapshot.data == null) {
                    Get.back(result: null);
                    return Container();
                  }
                  Map<int, String> disciplineMap =
                      snapshot.data! as Map<int, String>;
                  return ListView.builder(
                      itemCount: disciplineMap.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                                "${disciplineMap.values.elementAt(index)}"),
                            onTap: () => Get.back(
                                result: disciplineMap.keys.elementAt(index)),
                          ));
              }
            },
            future: Get.find<DatabaseController>().database.rawQuery(
                'select id from disciplines except '
                'select discipline_id from player_disciplines '
                'where player_id = ?',
                [
                  Get.find<DatabaseController>().characterId.value
                ]).then((value) => Get.find<DatabaseController>()
                    .database
                    .query(
                      'disciplines',
                      columns: ['id', 'name'],
                      where:
                          'id in (${List.generate(value.length, (index) => value[index]['id'] as int).join(", ")})',
                    )
                    .then((value) {
                  return Map<int, String>.fromIterable(value,
                      key: (iterator) => iterator['id'] as int,
                      value: (iterator) => iterator['name'] as String);
                })),
          ),
        );
}

class AddDisciplineButton extends CommonSpeedDialChild {
  AddDisciplineButton()
      : super(
          child: Icon(Icons.auto_fix_high),
          backgroundColor: Colors.green.shade300,
          label: "Add a discipline",
          onTap: () async {
            final ca =
                await Get.dialog<Discipline>(DisciplineDialog(null, index: 0));
            if (ca != null) {
              if (ca.system == null && ca.levels == null) return;
              DisciplineController bc = Get.find();
              bc.disciplines.add(ca);
              Get.find<DatabaseController>().addDiscipline(ca);
            }
          },
        );
}

class AddExistingDisciplineButton extends CommonSpeedDialChild {
  AddExistingDisciplineButton()
      : super(
          child: Icon(Icons.auto_fix_high),
          backgroundColor: Colors.blueAccent,
          label: "Add an existing discipline",
          onTap: () async {
            final id = await Get.dialog<int>(AddExistingDisciplineDialog());
            if (id != null) {
              DisciplineController bc = Get.find();
              Discipline newDisc = Discipline(id: id, txtId: null, level: 1);
              newDisc.fromDatabase(Get.find<DatabaseController>().database);
              bc.disciplines.add(newDisc);

              Get.find<DatabaseController>().database.insert(
                  'player_disciplines',
                  {
                    'player_id':
                        Get.find<DatabaseController>().characterId.value,
                    'discipline_id': id,
                    'level': 1,
                  },
                  conflictAlgorithm: ConflictAlgorithm.replace);
            }
          },
        );
}

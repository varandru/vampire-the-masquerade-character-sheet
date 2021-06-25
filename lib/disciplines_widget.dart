// A widget for a single discipline, ExpansionTile
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'common_widget.dart';
import 'disciplines.dart';

class DisciplineLevelsWidget extends StatelessWidget {
  DisciplineLevelsWidget(DisciplineLevels discipline, {required this.index})
      : _discipline = discipline;

  final DisciplineLevels _discipline;
  final int index;

  @override
  Widget build(BuildContext context) {
    List<Widget> disciplineDots = [];
    for (int i = 0; i < _discipline.levels.length; i++) {
      disciplineDots.addIf(
          _discipline.levels[i].level <= _discipline.level,
          DisciplineDotWidget(
            dot: _discipline.levels[i],
            dotIndex: i,
            disciplineIndex: index,
          ));
    }

    disciplineDots.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final ca =
                  await Get.dialog<DisciplineLevels>(DisciplineLevelsDialog(
                _discipline,
                index: index,
              ));
              if (ca != null) {
                final DisciplineController dc = Get.find();
                dc.disciplines[index] = ca;
              }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: _discipline.name));
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
      title: Text(_discipline.name),
      trailing: Container(
        constraints:
            BoxConstraints(maxWidth: _discipline.max.toDouble() * 20.0),
        child: NoTitleCounterWidget(
          current: _discipline.level,
          max: _discipline.max,
        ),
      ),
      children: disciplineDots,
    );
  }
}

class DisciplineIncrementalWidget extends StatelessWidget {
  DisciplineIncrementalWidget(DisciplineIncremental discipline,
      {required this.index})
      : _discipline = discipline;

  final DisciplineIncremental _discipline;
  final int index;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (_discipline.description != null)
      children.add(Text(_discipline.description!));

    children.add(RichText(
        text: TextSpan(
            // text: "System: ",
            style: DefaultTextStyle.of(context).style,
            children: [
          TextSpan(
            text: "System: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: _discipline.system),
        ])));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final ca = await Get.dialog<DisciplineIncremental>(
                  DisciplineIncrementalDialog(_discipline));
              if (ca != null) {
                final DisciplineController dc = Get.find();
                dc.disciplines[index] = ca;
              }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: _discipline.name));
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
      title: Text(_discipline.name),
      trailing: Container(
        constraints:
            BoxConstraints(maxWidth: _discipline.max.toDouble() * 20.0),
        child: NoTitleCounterWidget(
          current: _discipline.level,
          max: _discipline.max,
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

    return Obx(
      () => ListView.builder(
        itemBuilder: (context, i) {
          if (i == 0)
            return Text("Disciplines",
                style: Theme.of(context).textTheme.headline4);
          else if (dc.disciplines[i - 1] is DisciplineIncremental)
            return Obx(() => DisciplineIncrementalWidget(
                  dc.disciplines[i - 1] as DisciplineIncremental,
                  index: i - 1,
                ));
          else if (dc.disciplines[i - 1] is DisciplineLevels)
            return Obx(() => DisciplineLevelsWidget(
                  dc.disciplines[i - 1] as DisciplineLevels,
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
  }
}

class DisciplineDotWidget extends StatelessWidget {
  DisciplineDotWidget(
      {required DisciplineDot dot,
      required this.dotIndex,
      required this.disciplineIndex})
      : this.dot = dot;

  final DisciplineDot dot;
  final int dotIndex;
  final int disciplineIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300.0),
      child: ListTile(
        title: Text(dot.name),
        trailing: Container(
          constraints: BoxConstraints(maxWidth: 20.0 * dot.max.toDouble()),
          child: NoTitleCounterWidget(
            current: dot.level,
            max: dot.max,
          ),
        ),
        onTap: () => Get.dialog(DisciplineDotPopup(
          dot,
          dotIndex: dotIndex,
          disciplineIndex: disciplineIndex,
        )),
      ),
    );
  }
}

/// Use this whenever you want to edit a discipline
class DisciplineIncrementalDialog extends Dialog {
  DisciplineIncrementalDialog(DisciplineIncremental? disc)
      : this.disc = new DisciplineIncremental(
            name: disc?.name ?? "New Physical Discipline",
            level: disc?.level ?? 1,
            system: disc?.system ?? "",
            description: disc?.description);

  final DisciplineIncremental disc;

  @override
  Widget build(BuildContext context) {
    var discipline = disc.obs;

    return SimpleDialog(
      title: Text(discipline.value.name),
      children: [
        // Discipline level editor.
        Row(children: [
          Text('Current Level: '),
          IconButton(
              onPressed: () => discipline.update((val) => val?.level--),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
          Obx(() => Text("${discipline.value.level}")),
          IconButton(
              onPressed: () => discipline.update((val) {
                    val?.level++;
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
                  ..text = discipline.value.system,
                onChanged: (value) =>
                    discipline.update((val) => val?.system = value),
                keyboardType: TextInputType.multiline,
                maxLines: null),
          ],
        ),
        Row(children: [
          TextButton(
              child: Text('Cancel'), onPressed: () => Get.back(result: null)),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              if (discipline.value.name.isNotEmpty)
                Get.back(result: discipline.value);
              else
                Get.back(result: null);
            },
          )
        ], mainAxisAlignment: MainAxisAlignment.end),
      ],
    );
  }
}

/// Use this whenever you want to edit a discipline
class DisciplineLevelsDialog extends Dialog {
  DisciplineLevelsDialog(DisciplineLevels? disc, {required this.index})
      : this.disc = new DisciplineLevels(
            name: disc?.name ?? "New casting discipline",
            level: disc?.level ?? 1,
            levels: disc?.levels ?? [],
            description: disc?.description);

  final DisciplineLevels disc;
  final int index;

  @override
  Widget build(BuildContext context) {
    var discipline = disc.obs;

    return SimpleDialog(
      title: Text(discipline.value.name),
      children: [
        // Discipline level editor.
        Row(children: [
          Text('Current Level: '),
          IconButton(
              onPressed: () => discipline.update((val) => val?.level--),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
          Obx(() => Text("${discipline.value.level}")),
          IconButton(
              onPressed: () => discipline.update((val) {
                    val?.level++;
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

        Text(
          "Levels",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        // Obx(() =>
        Container(
          child: ListView.builder(
            itemBuilder: (context, i) => (i != discipline.value.levels.length)
                ? DisciplineDotWidget(
                    dot: discipline.value.levels[i],
                    dotIndex: i,
                    disciplineIndex: index,
                  )
                : TextButton(
                    onPressed: () async {
                      var dot = await Get.dialog<DisciplineDot>(
                          DisciplineDotDialog(null));
                      if (dot != null) discipline.value.levels.add(dot);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline),
                        Text("Add another discipline level")
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
            itemCount: discipline.value.levels.length + 1,
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            // )
          ),
          width: double.maxFinite,
        ),

        Row(children: [
          TextButton(
              child: Text('Cancel'), onPressed: () => Get.back(result: null)),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              if (discipline.value.name.isNotEmpty)
                Get.back(result: discipline.value);
              else
                Get.back(result: null);
            },
          )
        ], mainAxisAlignment: MainAxisAlignment.end),
      ],
    );
  }
}

/// Use this whenever you want to show info about a discipline level
class DisciplineDotPopup extends Dialog {
  DisciplineDotPopup(this.dot,
      {required this.disciplineIndex, required this.dotIndex});

  final DisciplineDot dot;
  final int disciplineIndex;
  final int dotIndex;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(Row(
      children:
          makeIconRow(dot.level, dot.max, Icons.circle, Icons.circle_outlined),
      mainAxisAlignment: MainAxisAlignment.center,
    ));

    if (dot.description != null) {
      children.add(ExpansionTile(
          title: Text("Description"), children: [Text(dot.description!)]));
    }

    children.add(
        ExpansionTile(title: Text("System"), children: [Text(dot.system)]));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final ca =
                  await Get.dialog<DisciplineDot>(DisciplineDotDialog(dot));
              if (ca != null) {
                final DisciplineController dc = Get.find();
                (dc.disciplines[disciplineIndex] as DisciplineLevels)
                    .levels[dotIndex] = ca;
              }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: dot.name));
              if (delete != null && delete == true) {
                final DisciplineController dc = Get.find();
                (dc.disciplines[disciplineIndex] as DisciplineLevels)
                    .levels
                    .removeAt(dotIndex);
                Get.back();
              }
            },
            icon: Icon(Icons.delete)),
      ],
    ));

    return SimpleDialog(title: Text(dot.name), children: children);
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
      Row(children: [
        Text('Level: '),
        IconButton(
            onPressed: () => dot.update((val) => val?.level--),
            icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
        Obx(() => Text("${dot.value.level}")),
        IconButton(
            onPressed: () => dot.update((val) {
                  val?.level++;
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
            keyboardType: TextInputType.multiline,
            maxLines: null)
      ]),
      ExpansionTile(title: Text("System"), children: [
        TextField(
            controller: TextEditingController()..text = dot.value.system,
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

class AddIncrementalDisciplineButton extends SpeedDialChild {
  AddIncrementalDisciplineButton(BuildContext context)
      : super(
          child: Icon(Icons.fitness_center),
          backgroundColor: Colors.red.shade300,
          label: "Add a physical discipline",
          labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            final ca = await Get.dialog<DisciplineIncremental>(
                DisciplineIncrementalDialog(null));
            if (ca != null) {
              DisciplineController bc = Get.find();
              bc.disciplines.add(ca);
            }
          },
        );
}

class AddLevelsDisciplineButton extends SpeedDialChild {
  AddLevelsDisciplineButton(BuildContext context)
      : super(
          child: Icon(Icons.auto_fix_high),
          backgroundColor: Colors.green.shade300,
          label: "Add a caster discipline",
          labelBackgroundColor: Theme.of(context).colorScheme.surface,
          onTap: () async {
            final ca = await Get.dialog<DisciplineLevels>(
                DisciplineLevelsDialog(null, index: 0));
            if (ca != null) {
              DisciplineController bc = Get.find();
              bc.disciplines.add(ca);
            }
          },
        );
}

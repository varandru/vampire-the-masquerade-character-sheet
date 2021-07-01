// A widget for a single discipline, ExpansionTile
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_widget.dart';
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
      children.add(Text(discipline.value.description!));

    if (_discipline.system != null) {
      children.add(RichText(
          text: TextSpan(
              // text: "System: ",
              style: DefaultTextStyle.of(context).style,
              children: [
            TextSpan(
              text: "System: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: discipline.value.system),
          ])));
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
                print(
                    "Updated. Name: ${dot.value.name}, level: ${dot.value.level}");
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
                    }
                  }),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red)),
          Obx(() => Text("${discipline.value.level}")),
          IconButton(
              onPressed: () => discipline.update((val) {
                    if (val != null) {
                      if (val.level < 10) val.level++;
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

    if (dot.value.description != null) {
      children.add(ExpansionTile(
          title: Text("Description"),
          children: [Obx(() => Text(dot.value.description!))]));
    }

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
                print(
                    "Should update, new name ${ca.name}, new level: ${ca.level}");
                dot.update((val) => val?.copy(ca));
                print("${dot.value.name}, ${dot.value.level}");
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
            }
          },
        );
}

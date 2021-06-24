// A widget for a single discipline, ExpansionTile
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_widget.dart';
import 'disciplines.dart';

class DisciplineLevelsWidget extends StatelessWidget {
  DisciplineLevelsWidget(DisciplineLevels discipline,
      {required this.updateCallback,
      required this.deleteCallback,
      required this.index})
      : _discipline = discipline;

  final DisciplineLevels _discipline;
  final int index;

  final Function(DisciplineLevels discipline, int index) updateCallback;
  final Function(int index) deleteCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> disciplineDots = [];
    for (int i = 0; i < _discipline.level; i++) {
      disciplineDots.add(DisciplineDotWidget(dot: _discipline.levels[i]));
    }

    disciplineDots.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              Get.defaultDialog();
              // final ca =
              //     await Get.dialog<ComplexAbility>(ComplexAbilityDialog(
              //   name: 'Edit ${attribute.name}',
              //   ability: attribute,
              // ));
              // if (ca != null) {
              //   updateCallback(ca, index);
              // }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: _discipline.name));
              if (delete != null && delete == true) {
                deleteCallback(index);
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
      {required this.updateCallback,
      required this.deleteCallback,
      required this.index})
      : _discipline = discipline;

  final DisciplineIncremental _discipline;
  final int index;

  final Function(DisciplineIncremental discipline, int index) updateCallback;
  final Function(int index) deleteCallback;

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
              Get.defaultDialog();
              // final ca =
              //     await Get.dialog<ComplexAbility>(ComplexAbilityDialog(
              //   name: 'Edit ${attribute.name}',
              //   ability: attribute,
              // ));
              // if (ca != null) {
              //   updateCallback(ca, index);
              // }
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              bool? delete =
                  await Get.dialog<bool>(DeleteDialog(name: _discipline.name));
              if (delete != null && delete == true) {
                deleteCallback(index);
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

    return ListView.builder(
      itemBuilder: (context, i) {
        if (i == 0)
          return Text("Disciplines",
              style: Theme.of(context).textTheme.headline4);
        else if (dc.disciplines[i - 1] is DisciplineIncremental)
          return DisciplineIncrementalWidget(
            dc.disciplines[i - 1] as DisciplineIncremental,
            updateCallback: (discipline, index) => null,
            deleteCallback: (index) => null,
            index: i - 1,
          );
        else if (dc.disciplines[i - 1] is DisciplineLevels)
          return DisciplineLevelsWidget(
            dc.disciplines[i - 1] as DisciplineLevels,
            updateCallback: (discipline, index) => null,
            deleteCallback: (index) => null,
            index: i - 1,
          );
        else
          return Placeholder();
      },
      itemCount: dc.disciplines.length + 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}

class DisciplineDotWidget extends StatelessWidget {
  DisciplineDotWidget({required DisciplineDot dot}) : this.dot = dot;

  final DisciplineDot dot;

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
        onTap: () => Get.dialog(DisciplineDotDialog(dot)),
      ),
    );
  }
}

class DisciplineIncrementalDialog extends Dialog {}

class DisciplineLevelsDialog extends Dialog {}

class DisciplineDotDialog extends Dialog {
  DisciplineDotDialog(this.dot);

  final DisciplineDot dot;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(Row(
      children:
          makeIconRow(dot.level, dot.max, Icons.circle, Icons.circle_outlined),
      mainAxisAlignment: MainAxisAlignment.center,
    ));

    if (dot.description != null) {
      children.add(
          Text("Description", style: Theme.of(context).textTheme.headline6));
      children.add(Text(dot.description ?? ""));
    }

    children.add(Text(
      "System",
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    ));
    children.add(Text(dot.system));

    return SimpleDialog(title: Text(dot.name), children: children);
  }
}

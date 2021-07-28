import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import 'common_logic.dart';
import 'common_widget.dart';
import 'database.dart';
import 'drawer_menu.dart';
import 'rituals.dart';

class RitualWidget extends StatelessWidget {
  RitualWidget(this._ritual);

  final Ritual _ritual;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_ritual.name),
      trailing: Container(
        constraints: BoxConstraints(maxWidth: 100.0),
        child: NoTitleCounterWidget(
          current: _ritual.level,
          max: 5,
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RitualPopup(ritual: _ritual);
            }).then((value) => null);
      },
    );
  }
}

class RitualPopup extends StatelessWidget {
  const RitualPopup({
    Key? key,
    required Ritual ritual,
  })  : _ritual = ritual,
        super(key: key);

  final Ritual _ritual;

  @override
  Widget build(BuildContext context) {
    final ritual = _ritual.obs;

    return SimpleDialog(
      title: Obx(() => Text(ritual.value.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4)),
      children: [
        Row(children: [
          Obx(() => Text("${ritual.value.schoolId} ritual",
              style: TextStyle(fontStyle: FontStyle.italic))),
          Obx(() => NoTitleCounterWidget(
                current: ritual.value.level,
                max: 5,
              )),
        ]),
        ritual.value.description != null
            ? Text("Description", style: Theme.of(context).textTheme.headline6)
            : Container(),
        ritual.value.description != null
            ? Obx(() => MarkdownBody(data: ritual.value.description!))
            : Container(),
        Text(
          "System",
          style: Theme.of(context).textTheme.headline6,
        ),
        Obx(() => MarkdownBody(data: ritual.value.system)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              onPressed: () async {
                var ca = await Get.dialog<Ritual>(RitualDialog(ritual.value));
                if (ca != null) {
                  ritual.update((val) => val?.copy(ca));

                  final RitualController rc = Get.find();
                  var index = rc.rituals.indexOf(ca);
                  if (index < 0) {
                    rc.rituals.add(ca);
                    Get.find<DatabaseController>().addOrUpdateRitual(ca);
                    Get.back();
                  } else {
                    rc.rituals[index] = ca;
                    Get.find<DatabaseController>().addOrUpdateRitual(ca);
                  }
                }
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                bool? delete = await Get.dialog<bool>(
                    DeleteDialog(name: ritual.value.name));

                if (delete != null && delete == true) {
                  final RitualController rc = Get.find();
                  rc.rituals.remove(ritual.value);

                  Get.find<DatabaseController>().database.delete(
                      'player_rituals',
                      where: 'player_id = ? and discipline_id = ?',
                      whereArgs: [
                        Get.find<DatabaseController>().characterId.value,
                        ritual.value.dbId
                      ]);

                  Get.back();
                }
              },
              icon: Icon(Icons.delete)),
        ])
      ],
    );
  }
}

class RitualDialog extends StatelessWidget {
  RitualDialog(this.ritual);

  final Ritual? ritual;

  @override
  Widget build(BuildContext context) {
    final _ritual = (ritual ??
            Ritual(
              dbId: null,
              id: "new_id",
              name: "New ritual",
            ))
        .obs;
    final bool replaceId = ritual == null;

    return SimpleDialog(
      title: Obx(
        () => Text(_ritual.value.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4),
      ),
      children: [
        TextField(
            controller: TextEditingController()..text = _ritual.value.name,
            onChanged: (value) => _ritual.update(
                  (val) {
                    val?.name = value;
                  },
                )),
        Row(
          children: [
            Text('Level: '),
            IconButton(
                onPressed: () => _ritual.update((val) {
                      if (val != null) {
                        if (val.level > 1) val.level--;
                      }
                    }),
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                )),
            Obx(() => Text("${_ritual.value.level}")),
            IconButton(
                onPressed: () => _ritual.update((val) {
                      if (val != null) {
                        if (val.level < 10) val.level++;
                      }
                    }),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                )),
          ],
        ),
        // TODO: this should pick schools from a dropdown
        TextField(
          controller: TextEditingController()..text = _ritual.value.school,
          onChanged: (value) => _ritual.update(
            (val) {
              val?.school = value;
            },
          ),
          decoration: InputDecoration(hintText: "Ritual's school"),
        ),
        TextField(
          controller: TextEditingController()
            ..text = _ritual.value.description ?? "",
          onChanged: (value) => _ritual.update(
            (val) {
              val?.description = value;
            },
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(hintText: "Ritual's mechanics"),
        ),
        TextField(
          controller: TextEditingController()..text = _ritual.value.system,
          onChanged: (value) => _ritual.update(
            (val) {
              val?.system = value;
            },
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(hintText: "Ritual's description"),
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
                if (_ritual.value.name.isNotEmpty) {
                  if (replaceId) {
                    Ritual result =
                        Ritual(id: identify(_ritual.value.name), dbId: null);
                    result.copy(_ritual.value);
                    Get.back(result: result);
                  } else
                    Get.back(result: _ritual.value);
                } else
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

class RitualSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RitualController rc = Get.find();
    if (rc.rituals.length == 0)
      return Obx(() => Container(
            height: rc.rituals.length.toDouble(),
          ));
    return Obx(
      () => ListView.builder(
        itemBuilder: (context, i) => (i == 0)
            ? Text("Rituals", style: Theme.of(context).textTheme.headline4)
            : Obx(() => RitualWidget(
                  rc.rituals[i - 1],
                )),
        itemCount: rc.rituals.length + 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class AddRitualButton extends CommonSpeedDialChild {
  AddRitualButton()
      : super(
          child: Icon(Icons.gesture),
          backgroundColor: Colors.blue.shade300,
          label: "Add a ritual",
          onTap: () async {
            final ca = await Get.dialog<Ritual>(RitualDialog(null));
            if (ca != null) {
              RitualController bc = Get.find();
              bc.rituals.add(ca);
              Get.find<DatabaseController>().addOrUpdateRitual(ca);
            }
          },
        );
}

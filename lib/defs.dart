import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_info_logic.dart';

class Attribute {
  Attribute(
      {required this.name,
      this.current = 1,
      this.min = 0,
      this.max = 5,
      this.specialization = "",
      this.description = ""});
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;
}

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

class AttributeWidget extends StatelessWidget {
  AttributeWidget({Key? key, required Attribute attribute})
      : this.attribute = attribute,
        super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = makeIconRow(
        attribute.current, attribute.max, Icons.circle, Icons.circle_outlined);
    final header = Text(
      attribute.name,
      overflow: TextOverflow.fade,
      softWrap: false,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: ListTile(
        title: header,
        subtitle: Text(attribute.specialization),
        trailing: Row(
          children: row,
          mainAxisSize: MainAxisSize.min,
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(attribute.name),
                  children: [
                    Text(attribute.description),
                  ],
                );
              }).then((value) => null);
        },
      ),
    );
  }
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

class MainInfoWidget extends StatelessWidget {
  MainInfoWidget(this._type);

  final MainInfoFieldType _type;

  @override
  Widget build(BuildContext context) {
    final MainInfo controller = Get.find();
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextButton(
        child: Obx(
          () => Text(
            "${controller.getByType(_type)}",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        onPressed: () async {
          TextEditingController _controller =
              TextEditingController(text: "${controller.getByType(_type)}");
          var string = await showDialog<String?>(
              context: context,
              builder: (context) => AlertDialog(
                    content: TextField(
                      controller: _controller,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            // TODO: Get Dialog
                            Navigator.of(context).pop(_controller.text);
                          },
                          child: Text("Ok")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(null);
                          },
                          child: Text("Cancel")),
                    ],
                  ));
          if (string != null) {
            print("$string");
            controller.setByType(_type, string);
          }
        },
      ),
    );
  }
}

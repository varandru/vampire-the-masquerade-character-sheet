import 'package:flutter/material.dart';

import 'common_widget.dart';
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
              return SimpleDialog(
                title: Text(_ritual.name),
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(_ritual.description),
                  Text(
                    "System",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(_ritual.system),
                ],
              );
            }).then((value) => null);
      },
    );
  }
}

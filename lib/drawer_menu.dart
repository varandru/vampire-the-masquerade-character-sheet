import 'package:flutter/material.dart';
import 'common.dart';

enum SelectedMenuItem { PrimaryInfo, Abilities }

class DrawerMenu extends Drawer {
  DrawerMenu(SelectedMenuItem item) : _item = item;

  final SelectedMenuItem _item;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Primary information'),
            trailing: Icon(Icons.face),
            tileColor: _item == SelectedMenuItem.PrimaryInfo
                ? Theme.of(context).buttonColor
                : Theme.of(context).canvasColor,
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return primaryInfoScaffold;
              }));
            },
          ),
          ListTile(
            title: Text('Abilities'),
            trailing: Icon(Icons.accessibility_new),
            tileColor: _item == SelectedMenuItem.Abilities
                ? Theme.of(context).buttonColor
                : Theme.of(context).canvasColor,
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return abilitiesScaffold;
              }));
            },
          ),
          ListTile(
            title: Text('Close'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    ;
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: Text('Pop!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

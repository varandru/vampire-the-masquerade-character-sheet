import 'package:flutter/material.dart';

class DrawerMenu extends Drawer {
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
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
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

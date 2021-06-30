import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vampite_character.dart';
import 'drawer_menu.dart';

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    var vc = Get.put(VampireCharacter());

    return FutureBuilder(
        future: vc.init(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              print("Loading");
              return CircularProgressIndicator();
            case ConnectionState.done:
              print("Done");
              return GetMaterialApp(
                home: PrimaryInfoScaffold(context),
              );
          }
        });
  }
}

class MenuScaffold extends StatelessWidget {
  MenuScaffold(
      {required String name,
      required Widget body,
      required SelectedMenuItem selectedItem,
      List<IconButton> actions = const [],
      this.floatingActionButton})
      : _name = name,
        _body = body,
        _item = selectedItem,
        _actions = [
              IconButton(
                onPressed: () {
                  final VampireCharacter vc = Get.find();
                  vc.load();
                },
                icon: Icon(Icons.file_download),
              ),
              IconButton(
                onPressed: () {
                  final VampireCharacter vc = Get.find();
                  vc.save();
                },
                icon: Icon(Icons.save),
              ),
            ] +
            actions;

  final String _name;
  final Widget _body;
  final SelectedMenuItem _item;
  final Widget? floatingActionButton;
  final List<IconButton> _actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        actions: _actions,
      ),
      body: _body,
      drawer: Drawer(
        child: DrawerMenu(_item),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

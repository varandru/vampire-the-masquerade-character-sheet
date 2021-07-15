import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vampire_the_masquerade_character_sheet/settings_widget.dart';

import 'vampite_character.dart';
import 'drawer_menu.dart';

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    var vc = Get.put(VampireCharacter());

    Get.put(Settings());

    WidgetsFlutterBinding.ensureInitialized();

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
              home: PrimaryInfoScaffold(),
              theme: ThemeData.light().copyWith(
                primaryColor: Colors.red,
                accentColor: Colors.redAccent,
                toggleableActiveColor: Colors.redAccent,
              ),
              darkTheme: ThemeData.dark().copyWith(
                  primaryColor: Colors.red,
                  accentColor: Colors.redAccent,
                  toggleableActiveColor: Colors.redAccent),
            );
        }
      },
    );
  }
}

class MenuScaffold extends Scaffold {
  MenuScaffold(
      {required String name,
      required Widget body,
      required SelectedMenuItem selectedItem,
      List<IconButton> actions = const [],
      CommonFloatingButton? floatingActionButton})
      : super(
          appBar: AppBar(
            title: Text(name),
            actions: actions,
          ),
          body: body,
          drawer: Drawer(
            child: ListTileTheme(
              child: DrawerMenu(selectedItem),
              selectedColor: Colors.redAccent,
            ),
          ),
          floatingActionButton: floatingActionButton,
        );
}

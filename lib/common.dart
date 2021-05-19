import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drawer_menu.dart';
import 'main_info.dart';
import 'attributes.dart';

const headerText = "Header text goes here";

// Основной виджет, пока что. На самом деле их несколько, но этот организует все
// Рисует главный виджет, включает в себя файлы с разделами
class VampireWidget extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(headerText),
        ),
        body: Center(
          child: Column(
            children: [
              CommonCharacterInfoWidget(),
              Flexible(child: AttributesSectionWidget()),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
        drawer: Drawer(
          child: DrawerMenu(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'database.dart';

class CharacterSelectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var users = Get.find<DatabaseController>()
        .database
        .query('characters', columns: ['id', 'name']);

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var users = snapshot.data as List<Map<String, Object?>>;
          print("Wow, ${users.length} characters");
          return Dialog(
              child: ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(
                "${users[index]['id'] as int}: ${users[index]['name'] as String})",
              ),
              trailing: Row(
                children: [
                  IconButton(
                      onPressed: () => Get.find<DatabaseController>()
                          .characterId
                          .value = users[index]['id'] as int,
                      icon: Icon(Icons.hail)),
                  IconButton(
                      onPressed: () => Get.find<DatabaseController>()
                          .database
                          .delete('characters',
                              where: 'id = ?',
                              whereArgs: [users[index]['id'] as int]),
                      icon: Icon(Icons.delete)),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            itemCount: users.length,
            shrinkWrap: true,
          ));
        } else
          return CircularProgressIndicator();
      },
      future: users,
    );
  }
}

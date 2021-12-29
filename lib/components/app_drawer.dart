import 'package:flutter/material.dart';
import 'package:ice2/views/map_view.dart';
import 'package:ice2/views/stores_list.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //width: 225,
        child: Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text("Ice cream app"),
          ),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Ice cream shops"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StoresList()));
              }),
          ListTile(
              leading: const Icon(Icons.navigation),
              title: const Text("Map"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapView()));
              })
        ],
      ),
    ));
  }
}

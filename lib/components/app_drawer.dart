import 'package:flutter/material.dart';
import 'package:ice2/views/map_view.dart';
import 'package:ice2/views/stores_list.dart';
import 'package:ice2/views/user_stores.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

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
            accountEmail: Text("Aplikacja do lodów"),
          ),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Lodziarnie"),
              onTap: () {
                Navigator.pushNamed(context, StoresList.id);
              }),
          ListTile(
              leading: const Icon(Icons.navigation),
              title: const Text("Mapa"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapView()));
              }),
          ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Moje lodziarnie"),
              onTap: () {
                Navigator.pushNamed(context, UserStores.id);
              })
        ],
      ),
    ));
  }
}

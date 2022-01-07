import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/storages/user_data.dart';
import 'package:ice2/views/store_details.dart';

class StoresList extends StatefulWidget {
  const StoresList({Key? key}) : super(key: key);

  static const String id = 'StoresList';

  @override
  _StoresListState createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  String search = '';
  final UserData _userData = UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void tryLogin() async {
    var email = await _userData.getEmail();
    var password = await _userData.getPassword();

    if (email != null && password != null) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        print('Zalogowano');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    tryLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              child: TextField(
                  onChanged: (String text) => search = text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Wpisz nazwę lodziarni, albo miejcowość')),
              padding: const EdgeInsets.only(top: 75)),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Stores')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            String name =
                                document.get("Name").toString().toLowerCase();
                            String city =
                                document.get("City").toString().toLowerCase();

                            if (name.contains(search.toLowerCase()) ||
                                city.contains(search.toLowerCase())) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StoreDetails(
                                              storeId: document.id)));
                                },
                                title: Text(document.get("Name")),
                                subtitle: Text(document.get("City")),
                              ));
                            } else {
                              return Container();
                            }
                          }).toList(),
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

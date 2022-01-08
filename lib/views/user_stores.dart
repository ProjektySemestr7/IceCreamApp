import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/storages/user_data.dart';
import 'package:ice2/views/add_store.dart';
import 'package:ice2/views/store_details.dart';
import 'package:ice2/views/store_edit.dart';

class UserStores extends StatefulWidget {
  const UserStores({Key? key}) : super(key: key);

  static const String id = 'UserStores';

  @override
  _UserStoresState createState() => _UserStoresState();
}

class _UserStoresState extends State<UserStores> {
  final UserData _userData = UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _email = '';

  void tryLogin() async {
    var email = await _userData.getEmail();
    var password = await _userData.getPassword();

    if (email != null && password != null) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        print('Zalogowano');
        setState(() {
          _email = email;
        });
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
    return SafeArea(
      child: Scaffold(
        body: _email == ''
            ? Container()
            : Column(
                children: [
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
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs.map((document) {
                                    String owner = document
                                        .get("Owner")
                                        .toString()
                                        .toLowerCase();

                                    String id = document.id;
                                    String name = document.get("Name");

                                    if (owner.toLowerCase() == _email) {
                                      return Dismissible(
                                        key: Key(id),
                                        background: slideRightBackground(),
                                        secondaryBackground:
                                            slideLeftBackground(),
                                        confirmDismiss: (direction) async {
                                          confirmDissmision(
                                              direction, name, id);
                                        },
                                        child: InkWell(
                                            child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoreDetails(
                                                            storeId:
                                                                document.id)));
                                          },
                                          title: Text(document.get("Name")),
                                          subtitle: Text(document.get("City")),
                                        )),
                                      );
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
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddStore()))
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edytuj",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Usuń",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future<bool?> confirmDissmision(
      DismissDirection direction, String name, String id) async {
    if (direction == DismissDirection.endToStart) {
      final bool? res = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Czy na pewno chcesz usunąć $name?"),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Anuluj",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    "Usuń",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    _firestore.collection("Stores").doc(id).delete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return res;
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StoreEdit(storeId: id)));
    }
  }
}

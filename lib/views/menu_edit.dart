import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/views/add_icecream.dart';
import 'package:ice2/views/icecream_edit.dart';

class MenuEdit extends StatefulWidget {
  const MenuEdit({Key? key, required this.storeId}) : super(key: key);
  final String storeId;

  @override
  _MenuEditState createState() => _MenuEditState();
}

class _MenuEditState extends State<MenuEdit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                          .doc(widget.storeId)
                          .collection("Icecreams")
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
                              String id = document.id;
                              String name = document.get("Name");

                              return Dismissible(
                                key: Key(id),
                                background: slideRightBackground(),
                                secondaryBackground: slideLeftBackground(),
                                confirmDismiss: (direction) async {
                                  confirmDissmision(
                                      direction, name, id, widget.storeId);
                                },
                                child: InkWell(
                                    child: ListTile(
                                  onTap: () {},
                                  title: Text(document.get("Name")),
                                  subtitle: Text(
                                      document.get("Price").toString() +
                                          " PLN"),
                                )),
                              );
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddIcecream(storeId: widget.storeId)))
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

  Future<bool?> confirmDissmision(DismissDirection direction, String name,
      String id, String storeId) async {
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
                    _firestore
                        .collection("Stores")
                        .doc(storeId)
                        .collection("Icecreams")
                        .doc(id)
                        .delete();
                    //setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return res;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IcecreamEdit(
                    storeId: storeId,
                    icecreamId: id,
                  )));
    }
  }
}

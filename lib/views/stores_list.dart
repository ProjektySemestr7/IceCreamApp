import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/views/store_details.dart';

class StoresList extends StatefulWidget {
  StoresList({Key? key}) : super(key: key);

  @override
  _StoresListState createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Stores').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                //Map<String, dynamic> xd = snapshot.data as Map<String, dynamic>;
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StoreDetails(storeId: document.id)));
                        },
                        title: Text(document.get("Name")),
                        subtitle: Text(document.get("City")),
                      ));
                    }).toList(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

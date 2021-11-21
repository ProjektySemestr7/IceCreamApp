import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreDetails extends StatefulWidget {
  StoreDetails({Key? key, required this.storeId}) : super(key: key);

  String storeId;

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Stores')
                  .doc(widget.storeId)
                  .collection("Icecreams")
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
                      return Card(
                          child: ListTile(
                        title: Text(document.get("Name")),
                        subtitle:
                            Text(document.get("Price").toString() + " PLN"),
                      ));
                    }).toList(),
                  );
                }
              }),
        ),
      ]),
    );
  }
}

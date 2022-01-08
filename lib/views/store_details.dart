import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/components/store_info_bar.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({Key? key, required this.storeId}) : super(key: key);

  final String storeId;

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
          StoreInfoBar(storeId: widget.storeId)
        ]),
        drawer: const AppDrawer(),
      ),
    );
  }
}

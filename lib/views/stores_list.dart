import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/views/store_details.dart';

class StoresList extends StatefulWidget {
  StoresList({Key? key}) : super(key: key);

  @override
  _StoresListState createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  String search = '';

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
              padding: const EdgeInsets.only(top: 50)),
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
    );
  }
}

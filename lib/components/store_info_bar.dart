import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/views/map_view.dart';

class StoreInfoBar extends StatelessWidget {
  const StoreInfoBar({Key? key, required this.storeId}) : super(key: key);
  final String storeId;

  @override
  Widget build(BuildContext context) {
    CollectionReference stores =
        FirebaseFirestore.instance.collection('Stores');

    return FutureBuilder<DocumentSnapshot>(
      future: stores.doc(storeId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var snapshotData = snapshot.data;

          return Container(
            decoration: const BoxDecoration(color: Colors.lightGreen),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      data['Name'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      data['Address'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MapView(defaultStoreId: snapshotData!.id)));
                    },
                    child: const Icon(Icons.navigation)),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

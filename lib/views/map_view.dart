import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/views/store_details.dart';

class MapView extends StatefulWidget {
  MapView({Key? key, this.defaultStoreId}) : super(key: key);

  String? defaultStoreId;
  double defaultLatitude = 51.11153139321595;
  double defaultLongitude = 17.03886984229546;
  DocumentSnapshot<Map<String, dynamic>>? defaultStore;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Set<Marker> _markers = {};

  Future<Set<Marker>> setMarkers() async {
    final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)), 'images/marker.png');
    var stores = await FirebaseFirestore.instance.collection('Stores').get();
    var storesDocs = stores.docs;
    Set<Marker> markers = {};
    for (var store in storesDocs) {
      markers.add(Marker(
          markerId: MarkerId(store.id),
          icon: icon,
          position: LatLng(double.parse(store.get("Latitude")),
              double.parse(store.get("Longitude"))),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoreDetails(storeId: store.id)));
          }));
    }
    return markers;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _markers = await setMarkers();

    setInitialCameraPostion(controller);

    setState(() {});
  }

  void setInitialCameraPostion(GoogleMapController controller) async {
    if (widget.defaultStoreId != null) {
      widget.defaultStore = await FirebaseFirestore.instance
          .collection("Stores")
          .doc(widget.defaultStoreId)
          .get();

      var latitude = double.parse(widget.defaultStore!.get("Latitude"));
      var longitude = double.parse(widget.defaultStore!.get("Longitude"));

      controller
          .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: GoogleMap(
              markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(widget.defaultLatitude, widget.defaultLongitude),
                  zoom: 15)),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

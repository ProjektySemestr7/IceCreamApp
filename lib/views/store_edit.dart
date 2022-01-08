import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/views/menu_edit.dart';
import 'package:ice2/views/store_details.dart';

class StoreEdit extends StatefulWidget {
  const StoreEdit({Key? key, required this.storeId}) : super(key: key);
  static const String id = "StoreEdit";
  final String storeId;

  @override
  _StoreEditState createState() => _StoreEditState();
}

class _StoreEditState extends State<StoreEdit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _longtitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _showSaveButton = false;

  @override
  void initState() {
    downloadStore();
    super.initState();
  }

  void downloadStore() async {
    var store = await _firestore.collection("Stores").doc(widget.storeId).get();

    setState(() {
      _nameController.text = store['Name'];
      _latitudeController.text = store['Latitude'];
      _longtitudeController.text = store['Longitude'];
      _cityController.text = store['City'];
      _addressController.text = store['Address'];
    });
  }

  void saveChanges() async {
    await _firestore.collection("Stores").doc(widget.storeId).update({
      "Name": _nameController.text,
      "City": _cityController.text,
      "Address": _addressController.text,
      "Longitude": _longtitudeController.text,
      "Latitude": _latitudeController.text
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetails(storeId: widget.storeId),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void onChanged() {
    setState(() {
      _showSaveButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _nameController.text == ''
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  TextFormField(
                    onChanged: (value) => onChanged(),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Nazwa lodziarni',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (value) => onChanged(),
                      controller: _cityController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Miasto',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (value) => onChanged(),
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Adres',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (value) => onChanged(),
                      controller: _longtitudeController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Długość geograficzna',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (value) => onChanged(),
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Szerokość geograficzna',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text(
                            "Edytuj menu",
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            onSurface: Colors.grey,
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MenuEdit(storeId: widget.storeId))),
                        ),
                        _showSaveButton == false
                            ? Container()
                            : TextButton(
                                child: const Text(
                                  "Zapisz zmiany",
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blueAccent,
                                  onSurface: Colors.grey,
                                ),
                                onPressed: () => saveChanges(),
                              ),
                      ],
                    ),
                  )
                ]),
              ),
        drawer: const AppDrawer(),
      ),
    );
  }
}

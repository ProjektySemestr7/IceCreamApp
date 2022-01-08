import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/storages/user_data.dart';
import 'package:ice2/views/stores_list.dart';

class AddStore extends StatefulWidget {
  const AddStore({Key? key}) : super(key: key);

  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _longtitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _showSaveButton = false;
  String _email = '';
  final UserData _userData = UserData();

  void saveChanges() async {
    await _firestore.collection("Stores").add({
      "Name": _nameController.text,
      "City": _cityController.text,
      "Address": _addressController.text,
      "Longitude": _longtitudeController.text,
      "Latitude": _latitudeController.text,
      "Owner": _email
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const StoresList(),
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
  void initState() {
    getUserEmail();
    super.initState();
  }

  void getUserEmail() async {
    var email = await _userData.getEmail();

    setState(() {
      _email = email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _showSaveButton == false || _email == ''
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ice2/components/app_drawer.dart';
import 'package:ice2/views/store_details.dart';

class IcecreamEdit extends StatefulWidget {
  const IcecreamEdit(
      {Key? key, required this.storeId, required this.icecreamId})
      : super(key: key);
  final String storeId;
  final String icecreamId;

  @override
  _IcecreamEditState createState() => _IcecreamEditState();
}

class _IcecreamEditState extends State<IcecreamEdit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _showSaveButton = false;

  @override
  void initState() {
    downloadIcecream();
    super.initState();
  }

  void downloadIcecream() async {
    var store = await _firestore
        .collection("Stores")
        .doc(widget.storeId)
        .collection("Icecreams")
        .doc(widget.icecreamId)
        .get();

    setState(() {
      _nameController.text = store['Name'];
      _priceController.text = store['Price'].toString();
    });
  }

  void saveChanges() async {
    await _firestore
        .collection("Stores")
        .doc(widget.storeId)
        .collection("Icecreams")
        .doc(widget.icecreamId)
        .update({
      "Name": _nameController.text,
      "Price": (int.parse(_priceController.text)),
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
                      labelText: 'Nazwa loda',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (value) => onChanged(),
                      controller: _priceController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Cena',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                    ),
                  ),
                  _showSaveButton == false
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: TextButton(
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
                        )
                ]),
              ),
        drawer: const AppDrawer(),
      ),
    );
  }
}

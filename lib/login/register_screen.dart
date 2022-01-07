import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice2/storages/user_data.dart';
import 'package:ice2/views/stores_list.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserData _userData = UserData();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String _email = '';
  late String _password = '';
  late String _name = '';
  late String _surname = '';

  bool _allow = false;

  void checkAllow() {
    if ((_email.isNotEmpty) &&
        (_password.isNotEmpty) &&
        (_name.isNotEmpty) &&
        (_surname.isNotEmpty)) {
      setState(() {
        _allow = true;
      });
    } else {
      setState(() {
        _allow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              onChanged: (input) {
                                _email = input;
                                checkAllow();
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hasło',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              obscureText: true,
                              onChanged: (input) {
                                _password = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Imię',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              onChanged: (input) {
                                _name = input;
                                checkAllow();
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nazwisko',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              onChanged: (input) {
                                _surname = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      _allow
                          ? ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);

                                  _firestore
                                      .collection('userData')
                                      .doc(_email)
                                      .set({
                                    'name': _name,
                                    'surname': _surname,
                                  });

                                  _userData.saveEmail(_email);
                                  _userData.savePassword(_password);
                                  _userData.saveLogged(true);

                                  Navigator.pushNamed(context, StoresList.id);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Text('Zarejestruj'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

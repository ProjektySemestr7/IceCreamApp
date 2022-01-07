import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice2/storages/user_data.dart';
import 'package:ice2/views/stores_list.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  static const String id = 'LogInScreen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final UserData _userData = UserData();
  final _auth = FirebaseAuth.instance;

  bool card = false;
  late String _email = '';
  late String _password = '';

  bool _allow = false;

  void checkAllow() {
    if ((_email.isNotEmpty) && (_password.isNotEmpty)) {
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
                                setState(() {
                                  _email = input;
                                  checkAllow();
                                });
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
                      _allow
                          ? ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);

                                  _userData.saveEmail(_email);
                                  _userData.savePassword(_password);
                                  _userData.saveLogged(true);

                                  Navigator.pushNamed(context, StoresList.id);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Text('Zaloguj'),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice2/login/register_screen.dart';

import 'login_screen.dart';

class LogRegScreen extends StatelessWidget {
  const LogRegScreen({Key? key}) : super(key: key);

  static const String id = 'log_rec_screen';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masz już konto?',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, LogInScreen.id);
                },
                child: const Text(
                  'Zaloguj',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'lub',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
                child: const Text(
                  'Zarejestruj',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

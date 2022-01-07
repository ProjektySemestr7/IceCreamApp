import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String _email = 'email';
  final String _password = 'password';
  final String _logged = 'logged';

  saveEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_email, email);
  }

  savePassword(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_password, password);
  }

  saveLogged(bool logged) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_logged, logged);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_email);
    return email;
  }

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString(_password);
    return password;
  }

  Future<bool?> getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool(_logged);
    return logged;
  }
}

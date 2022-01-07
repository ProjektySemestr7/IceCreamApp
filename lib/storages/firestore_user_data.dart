import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreUserData {
  late User _firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .doc(_firebaseUser.email)
            .get();
        return userData['name'];
      }
    } catch (e) {
      print(e);
      return 'Generyczne Imię';
    }
  }

  Future<String?> getUserSurName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .doc(_firebaseUser.email)
            .get();
        return userData['surname'];
      }
    } catch (e) {
      print(e);
      return 'Generyczne Nazwisko';
    }
  }

  Future<bool?> getUserCard() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .doc(_firebaseUser.email)
            .get();
        return userData['card'];
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

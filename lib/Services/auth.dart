import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<User?> login(String email, String password) async {
    var user = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic error) {
      if (error.code.contains('invalid-email')) {
        Fluttertoast.showToast(msg: "INVALID MAIL");
      }
      if (error.code.contains('user-not-found')) {
        Fluttertoast.showToast(msg: "INVALID MAIL");
      }
      if (error.code.contains('wrong-password')) {
        Fluttertoast.showToast(msg: "WRONG PASSWORD");
      }
    });
    return user.user;
  }

  Future<User?> signup(
      String firstName, String lastName, String email, String password) async {
    var user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic error) {
      if (error.code.contains('weak-password')) {
        Fluttertoast.showToast(msg: "weak-password");
      }

      if (error.code.contains('email-already-in-use')) {
        Fluttertoast.showToast(msg: "email-already-in-use");
      }
    });
    if (user.user!.uid.isNotEmpty) {
      await _firestore.collection("User").doc(user.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password
      });
    } else {
      Fluttertoast.showToast(msg: "cannot be empty");
    }
    return user.user;
  }

  //çıkış
  signout() async {
    return await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:sakayna/model/user.dart';
// import './query.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var userID;
  var userName;

  String errorMessage = "";

  getUserID() => this.userID;
  getUserName() => this.userName;

  setUserID(id) {
    this.userID = id;
  }

  setUserName(_userName) {
    this.userName = _userName;
  }

  UserData? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return UserData(user.uid, user.email);
  }

  Stream<UserData?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserData?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var credentials = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      errorMessage = "";
      return _userFromFirebase(credentials.user);
    } on FirebaseAuthException catch (e) {
      if (e.code.toString() == "user-not-found") {
        errorMessage = e.code.toString();
      } else if (e.code.toString() == "invalid-email") {
        errorMessage = e.code.toString();
      } else {
        errorMessage = "";
      }
      print(e);
      return null;
    }
  }

  Future<UserData?> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      var credentials = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      errorMessage = "";
      return _userFromFirebase(credentials.user);
    } on FirebaseAuthException catch (e) {
      if (e.code.toString() == "email-already-in-use") {
        errorMessage = e.code.toString();
      } else {
        errorMessage = "";
      }
      print(e);
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User _user = result.user!;
      return _user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}





























// class AuthenticationService extends ChangeNotifier {
//   final FirebaseAuth _firebaseAuth;
//   final que = Hquery();
//   var currentUser;

//   AuthenticationService(this._firebaseAuth);

//   /// Changed to idTokenChanges as it updates depending on more cases.
//   Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }

//   Future<String> signIn(
//       {required String email, required String password}) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return "Signed in";
//     } on FirebaseAuthException catch (e) {
//       return e.message!;
//     }
//   }

//   Future<String> signUp(
//       {required String email, required String password}) async {
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return "Signed up";
//     } on FirebaseAuthException catch (e) {
//       return e.message!;
//     }
//   }
// }

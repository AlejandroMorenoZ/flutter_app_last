import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';



abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
      String email,
      String password,



      );
  Future<String> createUserWithEmailAndPassword(
      String email,
      String password,


      );

  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithGoogle();

}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

    String verificationId;
    String phoneNo;
    String smsCode;


  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user.uid;
  }

  @override
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _auth.accessToken,
      idToken: _auth.idToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }



  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiqliq/dataBase.dart/db.dart';
import 'package:quiqliq/services/preferences.dart';

class Auth {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String email = "";
  static String uid = "";
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      email = userCredential.user!.email!;
      uid = userCredential.user!.uid;

      await Preferences.setEmail(email);
      await PreferencesRegister.setOk(uid);

      await Db.createCollecion(uid, email);

      return true;
    } catch (e) {
      debugPrint("❌ Error en signInWithGoogle: $e");
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    email = "";
    uid = "";
  }
}

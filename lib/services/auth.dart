import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String email = "";
  static String uid = "";

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithPopup(
        googleProvider,
      );
      email = userCredential.user!.email!;
      uid = userCredential.user!.uid;
      return true;

      // Trigger the authentication flow
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    email = "";
    uid = "";
  }

  static Future<bool> checkUserStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload(); // Actualiza el estado del usuario desde Firebase
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        return true; // El usuario ha sido deshabilitado
      }
    } catch (e) {
      if (e.toString().contains("USER_DISABLED")) {
        return true;
      }
    }
    return true;
  }
}

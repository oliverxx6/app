import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String email = "";
  static String uid = "";

  static Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow

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

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    email = "";
    uid = "";
  }

  static Future<bool> checkUserStatus() async {
    bool very = false;
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload(); // Actualiza el estado del usuario desde Firebase
        return very;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        very = true; // El usuario ha sido deshabilitado
      }
    } catch (e) {
      if (e.toString().contains("USER_DISABLED")) {
        very = true;
      }
    }
    return very;
  }
}

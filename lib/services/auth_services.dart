import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var logger = Logger();
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      logger.i('Usuario logueado: ${userCredential.user!.displayName}');

      return userCredential.user;
    } catch (e) {
      logger.e('Error en el inicio de sesión: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      await _googleSignIn.signOut();

      logger.i('Usuario deslogueado');
    } catch (e) {
      logger.e('Error al cerrar sesión: $e');
    }
  }
}

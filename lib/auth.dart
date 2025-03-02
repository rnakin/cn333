import 'package:firebase_auth/firebase_auth.dart';

class TQauth {
   static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  static Future<UserCredential> loginViaEmail(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      print("----");
      print(e.code);
      print("----");
      throw Exception(e);
    }
  }

}

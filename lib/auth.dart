import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TQauth {
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  static Future<UserCredential> loginViaEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<http.Response> sendPostRequest({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', ...headers},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception('Error sending POST request: $e');
    }
  }

  static Future<void> loginWithID(String username, String pass) async {
    final url = const String.fromEnvironment('TU_API_URL_1');
    final apiKey = const String.fromEnvironment('TU_API_KEY');

    final headers = {'Application-Key': apiKey};

    final body = {'UserName': username, 'PassWord': pass};

    try {
      final response = await sendPostRequest(
        url: url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Success: $data');
      } else {
        print('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
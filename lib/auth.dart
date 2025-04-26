import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TQauth {
  static Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
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

  static Future<UserCredential> createUserViaEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> saveIdEmailMapping(String id, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('idToEmail') // You can rename this collection if needed
          .doc(id)
          .set({'email': email});
      debugPrint("ID to Email mapping saved successfully.");
    } catch (e) {
      debugPrint("Failed to save ID to Email mapping: $e");
      throw e;
    }
  }

  static Future<UserCredential> loginViaID(String id, String password) async {
    String email;
    //Case 1 Known user
    //Step 1 Using id, fetch email
    //Step 2 Use email to login with password
    //Step 3 return credential
    try {
      email = await fetchEmail(id);
      final credential = await loginViaEmail(email, password);
      return credential;
    } catch (e) {
      //Case 2 Student, but new user
      //Step 1 Using id and password, fetch email from tu api
      debugPrint("fetching email failed, verify with TU ...");
      final personInfoResponse = await verifyID(id, password);
      debugPrint("verified");
      if (personInfoResponse['status'] == true) {
        email = personInfoResponse['email'];
      } else {
        debugPrint("ID verification failed.");
        throw Exception("ID verification failed.");
      }
    }
    //Step 2 Create user with the email and pass on firebase
    try {
      final newCredential = await createUserViaEmail(email, password);
      await saveIdEmailMapping(id, email);

      debugPrint("User account created for $email and ID mapping saved.");
      return newCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        "FirebaseAuthException during user creation: ${e.code} - ${e.message}",
      );
      rethrow;
    } catch (e) {
      debugPrint("Unexpected error during user creation: $e");
      rethrow;
    }
  }

  static Future<String> fetchEmail(String id) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('idToEmail')
              .doc(id)
              .get();

      if (doc.exists && doc.data()!.containsKey('email')) {
        return doc.data()!['email'] as String;
      } else {
        debugPrint("No email found for ID: $id");
        return "";
      }
    } catch (e) {
      debugPrint("Error fetching email: $e");
      return "";
    }
  }

  static Future<Map<String, dynamic>> verifyID(
    String username,
    String password,
  ) async {
    final String? apiUrl = dotenv.env['TU_API_URL_1'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception('❌ TU_API_URL_1 is not set in environment.');
    }

    try {
      final Map<String, String> credentials = {
        'UserName': username,
        'PassWord': password,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(credentials),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ verify OK");
        debugPrint("📨 Raw response body: ${response.body}");

        if (response.body.isEmpty) {
          throw Exception("❌ Empty response from TU API.");
        }

        final decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw Exception("❌ Invalid response format from TU API.");
        }

        debugPrint("🔍 Decoded JSON: $decoded");
        return decoded;
      } else {
        throw Exception(
          '❌ Failed to authenticate. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('❌ Failed to communicate with the server: $e');
    }
  }
}

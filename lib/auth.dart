import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      print("ID to Email mapping saved successfully.");
    } catch (e) {
      print("Failed to save ID to Email mapping: $e");
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
      print("fetching email failed, verify with TU ...");
      final personInfoResponse = await verifyID(id, password);
      if (personInfoResponse['status'] == true) {
        email = personInfoResponse['email'];
      } else {
        print("ID verification failed.");
        throw Exception("ID verification failed.");
      }
    }
    //Step 2 Create user with the email and pass on firebase
    try {
      final newCredential = await createUserViaEmail(email, password);
      await saveIdEmailMapping(id, email);

      print("User account created for $email and ID mapping saved.");
      return newCredential;
    } on FirebaseAuthException catch (e) {
      print(
        "FirebaseAuthException during user creation: ${e.code} - ${e.message}",
      );
      rethrow;
    } catch (e) {
      print("Unexpected error during user creation: $e");
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
        print("No email found for ID: $id");
        return "";
      }
    } catch (e) {
      print("Error fetching email: $e");
      return "";
    }
  }

  static Future<Map<String, dynamic>> verifyID(
    String username,
    String password,
  ) async {
    String apiUrl = dotenv.env['TU_API_URL_1']!;
    try {
      final Map<String, String> credentials = {
        'UserName': username,
        'PassWord': password,
      };

      // POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(credentials),
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to authenticate. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to communicate with the server: $e');
    }
  }
}

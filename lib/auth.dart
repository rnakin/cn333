import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<UserCredential> loginViaID(
    String id,
    String password,
  ) async {

    try {
      String email = await fetchEmail(id);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
  


  static Future<String> fetchEmail(String id) async {
  try {
    final doc = await FirebaseFirestore.instance
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

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuquest/models/class.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> get userId async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User not logged in");
    }
  }

  static Future<List<ClassModel>> getClassesForDay(String day) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('schedule')
            .doc(day)
            .collection('classes')
            .get();

    return snapshot.docs
        .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addClassForDay(String day, ClassModel classModel) async {
    final uid = await userId;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('schedule')
        .doc(day)
        .collection('classes')
        .add(classModel.toMap());
  }

  Future<void> deleteClass(String day, String classId) async {
    final uid = await userId;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('schedule')
        .doc(day)
        .collection('classes')
        .doc(classId)
        .delete();
  }

  Future<void> updateClass(
    String day,
    String classId,
    ClassModel classModel,
  ) async {
    final uid = await userId;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('schedule')
        .doc(day)
        .collection('classes')
        .doc(classId)
        .update(classModel.toMap());
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/model.dart';

class FavProvider with ChangeNotifier {
  List<Post> _favs = [];

  List<Post> get favs => _favs;

  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isFavorite(Post post) {
    return _favs.any((p) => p.id == post.id);
  }

  Future<void> add(Post post) async {
    _favs.add(post);
    notifyListeners();
    await _saveToFirebase();
  }

  Future<void> remove(Post post) async {
    _favs.removeWhere((p) => p.id == post.id);
    notifyListeners();
    await _saveToFirebase();
  }

  Future<void> _saveToFirebase() async {
    if (user == null) return;

    final favData = _favs.map((post) => {
      'id': post.id,
      'topic': post.topic,
      'detail': post.detail,
      'imageUrl': post.imageUrl,
      'isNetworkImage': post.isNetworkImage,
      'createdAt': post.createdAt.toIso8601String(),
      if (post is Event) ...{
        'startDate': post.startDate.toIso8601String(),
        'endDate': post.endDate.toIso8601String(),
      },
    }).toList();

    await _firestore.collection('favorites').doc(user!.uid).set({
      'posts': favData,
    });
  }

  Future<void> loadFromFirebase() async {
    if (user == null) return;

    final doc = await _firestore.collection('favorites').doc(user!.uid).get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['posts'] != null) {
        _favs = (data['posts'] as List).map<Post>((p) {
          if (p['startDate'] != null && p['endDate'] != null) {
            return Event(
              id: p['id'],
              topic: p['topic'],
              detail: p['detail'],
              imageUrl: p['imageUrl'],
              isNetworkImage: p['isNetworkImage'],
              createdAt: DateTime.parse(p['createdAt']),
              startDate: DateTime.parse(p['startDate']),
              endDate: DateTime.parse(p['endDate']),
              creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
            );
          } else {
            return Post(
              id: p['id'],
              topic: p['topic'],
              detail: p['detail'],
              imageUrl: p['imageUrl'],
              isNetworkImage: p['isNetworkImage'],
              createdAt: DateTime.parse(p['createdAt']),
              creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
            );
          }
        }).toList();
        notifyListeners();
      }
    }
  }
}

import 'package:flutter/material.dart';
import '../models/model.dart';

class FavProvider with ChangeNotifier {
  final List<Post> _favoritePosts = [];

  // ✅ สร้าง getter ชื่อ favs
  List<Post> get favs => _favoritePosts;

  // เพิ่มเมธอดตรวจสอบการมีอยู่ด้วย id
  bool isExist(String postId) {
    return _favoritePosts.any((post) => post.id == postId);
  }

  // แก้ไขเมธอด add ให้ตรวจสอบก่อนเพิ่ม
  void add(Post post) {
    if (!isExist(post.id)) {
      _favoritePosts.add(post);
      notifyListeners();
    }
  }

  // แก้ไขเมธอด remove ให้ทำงานมีประสิทธิภาพมากขึ้น
  void remove(Post post) {
    _favoritePosts.removeWhere((p) => p.id == post.id);
    notifyListeners();
  }

  // เมธอดตรวจสอบสถานะ Favorite
  bool isFavorite(Post post) {
    return isExist(post.id);
  }

  bool containsPost(String postId) {
  return _favoritePosts.any((post) => post.id == postId);
  }
}

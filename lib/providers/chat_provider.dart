import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';


// Create a chat object that only has 2 users inside, talking to each other.
class ChatConnection extends ChangeNotifier {
  User user1 = User(id: '1', name: 'User1', email:'user1@example.com');
  User user2 = User(id: '2', name: 'User2', email:'user2@example.com');

  // Messages is stored as a chat object, User + text + time.
  List<Chat> messages = [];

  late User currentUser;

  // Create the object.
  ChatConnection() {
    currentUser = user1;
  }

  // Simulate 2 Users talking to each other by swapping.
  void switchUser() {
    if (currentUser.id == user1.id) {
      currentUser = user2;
    } else {
      currentUser = user1;
    }
    notifyListeners();
  }


  // When the function is called (Message sent), Chat object is added to messages List.
  void sendMessage(String text) {
    if (text.isNotEmpty) {
      messages.add(Chat(text: text, user: currentUser, time:'22-10-2025'));
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
 
class ChatBoardPage extends StatelessWidget {
  const ChatBoardPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Board")),
      body: const Center(child: Text("Chat Content")),
    );
  }
}
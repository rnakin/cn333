import 'package:flutter/material.dart';
 
class QuestBoardPage extends StatelessWidget {
  const QuestBoardPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quest Board")),
      body: const Center(child: Text("Quest Content")),
    );
  }
}
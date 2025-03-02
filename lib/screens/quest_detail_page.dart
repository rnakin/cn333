import 'package:flutter/material.dart';
import "package:tuquest/models/quest.dart";
import 'edit_quest_page.dart';
import 'dart:io';

class QuestDetailPage extends StatefulWidget {
  final Quest quest;
  final Function(Quest) onQuestUpdated;

  QuestDetailPage({required this.quest, required this.onQuestUpdated});

  @override
  _QuestDetailPageState createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  void _navigateToEditQuestPage() async {
    Quest? updatedQuest = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuestPage(quest: widget.quest),
      ),
    );

    if (updatedQuest != null) {
      widget.onQuestUpdated(updatedQuest);
      setState(() {}); // Refresh UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quest.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // ✏️ Edit icon
            onPressed: _navigateToEditQuestPage,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.quest.imagePath?.isNotEmpty == true
    ? Image.file(File(widget.quest.imagePath!), height: 150)
    : Icon(Icons.image, size: 150),
            SizedBox(height: 10),
            Text(widget.quest.description??'', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

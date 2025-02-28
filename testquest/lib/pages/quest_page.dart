import 'package:flutter/material.dart';
import '../models/quest.dart';
import 'quest_detail_page.dart';
import 'add_quest_page.dart';
import 'dart:io';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  List<Quest> quests = [];

  void _navigateToAddQuestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddQuestPage(
              onQuestAdded: (newQuest) {
                setState(() {
                  quests.add(newQuest);
                });
              },
            ),
      ),
    );
  }

  void _updateQuest(int index, Quest updatedQuest) {
    setState(() {
      quests[index] = updatedQuest; // Update the quest in the list
    });
  }

  void _navigateToQuestDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QuestDetailPage(
              quest: quests[index],
              onQuestUpdated:
                  (updatedQuest) => _updateQuest(index, updatedQuest),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quest')),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                quests[index].imagePath.isNotEmpty
                    ? Image.file(
                      File(quests[index].imagePath),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                    : Icon(Icons.image, size: 50), // Default icon if no image
            title: Text(quests[index].title),
            subtitle: Text(quests[index].description),
            onTap: () => _navigateToQuestDetailPage(index), // Open Detail Page
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddQuestPage,
        child: Icon(Icons.add),
      ),
    );
  }
}

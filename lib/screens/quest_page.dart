import 'package:flutter/material.dart';
import 'package:tuquest/models/quest.dart';
import 'quest_detail_page.dart';
import 'add_quest_page.dart';
import 'dart:io';
import 'package:tuquest/models/quest.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  late Future<List<Quest>> _questsFuture;

  @override
  void initState() {
    super.initState();
    _questsFuture = loadQuests(); 
  }


List<Quest> quests = [];

Future<List<Quest>> loadQuests() async {
    try {
      List<Quest> q = await Quest.getQuests();
          setState(() {quests = q;});
      return q;
    } catch (error) {
      throw Exception("error-load-quest");
    }
  }


void _navigateToAddQuestPage() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddQuestPage()),
  );

  if (result == true) {
    // refresh the FutureBuilder
    setState(() {}); 
  }
}



  // void _navigateToQuestDetailPage(int index) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder:
  //           (context) => QuestDetailPage(
  //             quest: quests[index],
  //             onQuestUpdated:
  //                 (updatedQuest) => _updateQuest(index, updatedQuest),
  //           ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quests')),
      body: FutureBuilder<List<Quest>>(
        future: _questsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quests available.'));
          }

          final quests = snapshot.data!;

          return ListView.builder(
  itemCount: quests.length,
  itemBuilder: (context, index) {
    final quest = quests[index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: SizedBox(
          width: 50, // Ensures consistent layout
          height: 50,
          child: quest.imagePath != null && quest.imagePath!.isNotEmpty
              ? Image.file(
                  File(quest.imagePath!), 
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                )
              : const Icon(Icons.image, size: 50),
        ),
        title: Text(quest.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(quest.description ?? ''),
      ),
    );
  },
);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddQuestPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

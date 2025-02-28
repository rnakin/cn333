import 'package:flutter/material.dart';
import 'quest_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuestBoard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestPage()),
                );
              },
              child: Text('Quest'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Event')),
          ],
        ),
      ),
    );
  }
}

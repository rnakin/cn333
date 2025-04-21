import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuquest/screens/announcement_page.dart';

class AnnouncementBox extends StatelessWidget {
  const AnnouncementBox ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .limit(1) // Only show the latest
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading announcement.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data?.docs;
        if (docs == null || docs.isEmpty) {
          return const Text('No announcements at this time.');
        }

        final data = docs.first.data() as Map<String, dynamic>;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          color: Colors.amber.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12), // ripple effect rounded
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnnouncementDetailPage(
                    title: data['title'],
                    message: data['message'],
                    imagePath: data['imagePath'],
                    imagePathTwo: data['imagePathTwo'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['title'] ?? 'Announcement',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap here to read more',
                    style: const TextStyle(fontSize: 14,
                      color: Colors.grey, 
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

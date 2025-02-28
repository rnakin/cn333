import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String eventName;
  final DateTime eventDate;
  final Function(DateTime, String) onDelete;

  const EventDetailPage({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(eventName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Event: $eventName', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Date: ${eventDate.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onDelete(eventDate, eventName);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Event'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;
  final String currentUserId;
  final Function(String id) onDelete;

  const EventDetailPage({
    super.key,
    required this.event,
    required this.currentUserId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${event.title}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Date: ${event.startDate.toLocal()}'),
            Text('To: ${event.endDate.toLocal()}'),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('Details: ${event.description}'),
            ],
            if (event.imageUrl != null && event.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Image.network(event.imageUrl!),
            ],
            const Spacer(),
            if (event.createdBy == currentUserId)
              ElevatedButton(
                onPressed: () {
                  onDelete(event.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Event'),
              )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../pages/event_detail_page.dart';

class EventListWidget extends StatelessWidget {
  final List<EventModel> events;
  final Function(DateTime, String) onDelete;

  const EventListWidget({
    super.key,
    required this.events,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No events for this month.')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text('Date: ${event.date.toLocal().toString().split(' ')[0]}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    eventName: event.title,
                    eventDate: event.date,
                    onDelete: onDelete,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

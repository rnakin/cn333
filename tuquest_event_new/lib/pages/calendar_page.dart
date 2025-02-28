import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_list_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<String>> _events = {};

  // Get events for the current month
  List<EventModel> _getEventsForMonth(DateTime month) {
    return _events.entries
        .where((entry) =>
            entry.key.year == month.year && entry.key.month == month.month)
        .expand((entry) =>
            entry.value.map((event) => EventModel(date: entry.key, title: event)))
        .toList();
  }

  // Add new event
  void _addEvent(DateTime date, String title) {
    setState(() {
      _events.putIfAbsent(date, () => []).add(title);
    });
  }

  // Delete an event
  void _deleteEvent(DateTime date, String title) {
    setState(() {
      _events[date]?.remove(title);
      if (_events[date]?.isEmpty ?? false) {
        _events.remove(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForMonth(_focusedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: Column(
        children: [
          CalendarWidget(
            focusedDay: _focusedDay,
            events: _events,
            onMonthChanged: (day) => setState(() => _focusedDay = day),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddEventDialog(context),
            child: const Text('Add Event'),
          ),
          const SizedBox(height: 10),
          EventListWidget(events: events, onDelete: _deleteEvent),
        ],
      ),
    );
  }

  // Add Event Dialog
  void _showAddEventDialog(BuildContext context) {
    DateTime selectedDate = _focusedDay;
    final TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _focusedDay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  setState(() => selectedDate = pickedDate);
                }
              },
            ),
            TextField(
              controller: eventController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                _addEvent(selectedDate, eventController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }
}

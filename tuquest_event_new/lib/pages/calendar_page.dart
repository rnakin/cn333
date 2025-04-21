import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_list_widget.dart';
import 'add_edit_event_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  List<EventModel> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    setState(() {
      _allEvents = snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    });
  }

  List<EventModel> _getEventsForFocusedMonth() {
    return _allEvents.where((event) =>
      event.startDate.year == _focusedDay.year &&
      event.startDate.month == _focusedDay.month
    ).toList();
  }

  Future<void> _addEvent({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    String? imageUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final event = EventModel(
      id: '',
      title: title,
      description: description,
      startDate: start,
      endDate: end,
      imageUrl: imageUrl,
      createdBy: user.uid,
    );

    await FirebaseFirestore.instance.collection('events').add(event.toMap());
    await _loadEvents(); // Refresh
  }

  Future<void> _deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
    await _loadEvents();
  }

  Map<DateTime, List<String>> _groupEventsByDate(List<EventModel> events) {
    Map<DateTime, List<String>> data = {};
    for (var event in events) {
      final date = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      if (!data.containsKey(date)) {
        data[date] = [];
      }
      data[date]!.add(event.title);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final currentUserId = user?.uid ?? '';

    final eventsForMonth = _getEventsForFocusedMonth();
    final eventsMap = _groupEventsByDate(_allEvents); // Group all for calendar

    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: Column(
        children: [
          CalendarWidget(
            focusedDay: _focusedDay,
            events: eventsMap,
            onMonthChanged: (newDay) {
              setState(() {
                _focusedDay = newDay;
              });
            },
          ),
          EventListWidget(
            events: eventsForMonth,
            currentUserId: currentUserId,
            onDelete: _deleteEvent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditEventPage(
                onSave: _addEvent,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

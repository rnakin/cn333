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
  final currentUser = FirebaseAuth.instance.currentUser!;
  DateTime _focusedDay = DateTime.now();

  Future<List<EventModel>> _fetchEventsForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);

    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }

  void _goToAddEventPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditEventPage(
          onSave: (event) async {
            await FirebaseFirestore.instance.collection('events').add(event.toMap());
            setState(() {}); // Refresh
          },
          currentUserId: currentUser.uid,
        ),
      ),
    );
  }

  void _deleteEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: FutureBuilder<List<EventModel>>(
        future: _fetchEventsForMonth(_focusedDay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data ?? [];

          return Column(
            children: [
              CalendarWidget(
                focusedDay: _focusedDay,
                events: _groupEventsByDate(events),
                onMonthChanged: (newDay) => setState(() => _focusedDay = newDay),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _goToAddEventPage,
                child: const Text('Add Event'),
              ),
              const SizedBox(height: 10),
              EventListWidget(
                events: events,
                currentUserId: currentUser.uid,
                onDelete: _deleteEvent,
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<String>> _groupEventsByDate(List<EventModel> events) {
    final map = <DateTime, List<String>>{};
    for (var event in events) {
      final date = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      map.putIfAbsent(date, () => []).add(event.title);
    }
    return map;
  }
}

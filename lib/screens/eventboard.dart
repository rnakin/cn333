import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuquest/pages/add_event_page.dart';
import 'package:tuquest/widgets/add_announce.dart';
import 'package:tuquest/widgets/bottom_nav.dart';
import 'eventdetail.dart';
import 'package:tuquest/widgets/announcement_box.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventBoardPage extends StatefulWidget {
  const EventBoardPage({super.key});

  @override
  _EventBoardPageState createState() => _EventBoardPageState();
}

class _EventBoardPageState extends State<EventBoardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  
  // กำหนดข้อมูลกิจกรรมแบบแมนนวล (ในอนาคตจะดึงจาก Firestore)
  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2025, 2, 2): [
      {"title": "นิทรรศการดอกไม้", "time": "11:30 am - 5:00 pm", "location": "สวนป๋วย"}
    ],
    DateTime(2025, 2, 21): [
      {"title": "Engineer Job Fair", "time": "11:30 am - 5:00 pm", "location": "คณะวิศวกรรมศาสตร์, ชั้น 2"}
    ],
    DateTime(2025, 2, 26): [
      {"title": "กิจกรรมอื่นๆ", "time": "10:00 am - 4:00 pm", "location": "มหาวิทยาลัย"}
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Event",
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFFA00000), Color(0xFFFF8000)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildAnnouncement(context),
                  const SizedBox(height: 20),

                  _buildCalendar(),
                  const SizedBox(height: 20),

                  Text("This month", style: _headerTextStyle()),
                  const SizedBox(height: 10),

                  _buildEventCards(context),
                  const SizedBox(height: 80), // extra space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: const Color.fromARGB(255, 255, 255, 255),
      onTap: () {
        final user = FirebaseAuth.instance.currentUser;
        final email = user?.email ?? '';

        if (email.endsWith('@tuquest.com')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddAnnouncePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access Denied.')),
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.add, size: 28),
      ),
    ),
    const SizedBox(height: 16),
    InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: const Color.fromARGB(255, 255, 255, 255),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEventPage()),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.calendar_today, size: 28),
      ),
    ),
  ],
),

      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000000), Color(0xFFFF0004)],
        ),
      ),
    );
  }

    ///////////////////////////////////////////////////////////
    ///
    /// Announcement Box 
    ///
    ////////////////////////////////////////////////////////
    Widget _buildAnnouncement(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 180,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnnouncementBox(),
      );
    }
    ///////////////////////////////////////////////////////////////////

  Widget _buildCalendar() {
    // DateTime _focusedDay = DateTime.now();
    // DateTime? _selectedDay;

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        markerDecoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
      ),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; 
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // List<Widget> _buildEventCards(BuildContext context) {
  // final selectedDayKey = _normalizeDate(_selectedDay!);
  
  Widget _buildEventCards(BuildContext context) {
    final selectedDayKey = _normalizeDate(_selectedDay!);

    final DateTime startOfDay = DateTime(
      selectedDayKey.year,
      selectedDayKey.month,
      selectedDayKey.day,
    );

    final DateTime endOfDay = DateTime(
      selectedDayKey.year,
      selectedDayKey.month,
      selectedDayKey.day,
      23,
      59,
      59,
      999,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No events for this day.");
        }

        final events = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        const List<String> monthNames = [
          "Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ];

        String monthAbbreviation = monthNames[_selectedDay!.month - 1];

        return Column(
          children: events.map((event) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(eventData: event),
                  ),
                );
              },
              child: Card(
                color: Colors.orange.shade300,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_selectedDay?.day} $monthAbbreviation ${_selectedDay?.year}",
                        style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event["title"] ?? "No Title",
                        style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(event["time"] ?? "No Time", style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(event["location"] ?? "No Location", style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  TextStyle _headerTextStyle() {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}

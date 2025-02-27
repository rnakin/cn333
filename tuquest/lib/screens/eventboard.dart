import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuquest/widgets/bottom_nav.dart';
import 'eventdetail.dart';

class EventBoardPage extends StatefulWidget {
  const EventBoardPage({super.key});

  @override
  _EventBoardPageState createState() => _EventBoardPageState();
}

class _EventBoardPageState extends State<EventBoardPage> {
  DateTime _selectedDay = DateTime.now();

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

          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
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
          ),

          Positioned(
            top: 130,
            left: 20,
            right: 20,
            child: _buildCalendar(),
          ),

          Positioned(
            top: 400,
            left: 20,
            child: Text("This month", style: _headerTextStyle()),
          ),

          Positioned(
            top: 430,
            left: 20,
            right: 20,
            child: Column(
              children: _buildEventCards(context),
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

  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: DateTime.now(),
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
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
    );
  }

  List<Widget> _buildEventCards(BuildContext context) {
    if (!_events.containsKey(_selectedDay)) return [];

    return _events[_selectedDay]!.map((event) {
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
                  "${_selectedDay.day} Feb",
                  style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  event["title"]!,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(event["time"]!, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(event["location"]!, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  TextStyle _headerTextStyle() {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}

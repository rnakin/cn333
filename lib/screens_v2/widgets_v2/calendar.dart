import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSection extends StatefulWidget {
  final Function(DateTime selectedDay)? onDateSelected;

  const CalendarSection({super.key, this.onDateSelected});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    // Check if user is admin
    _checkIfAdmin();
  }

  // Check if the current user is an admin
  Future<void> _checkIfAdmin() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
        setState(() {
          _isAdmin = true;
        });
      }
    }
  }

  // Fetch events from Firestore for a specific day
  List<dynamic> _getEventsForDay(DateTime day) {
    List<dynamic> events = [];
    _firestore
        .collection('events')
        .where('date', isEqualTo: day.toIso8601String())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        events.add(doc.data());
      });
    });
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    _selectedDay ??= today;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          child: Text(
            'ปฏิทินกิจกรรม',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA00000),
            ),
          ),
        ),

        // Calendar Box
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9D00),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              // Header (Month)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month - 1,
                            1,
                          );
                        });
                      },
                    ),
                    Text(
                      '${_monthName(_focusedDay.month)} ${_focusedDay.year}',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month + 1,
                            1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),

              // TableCalendar
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  if (widget.onDateSelected != null) {
                    widget.onDateSelected!(selectedDay);
                  }
                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                eventLoader: _getEventsForDay,
                daysOfWeekHeight: 36,
                rowHeight: 42,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: const BoxDecoration(
                    color: Color(0xFFA00000),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFFF9D00),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFA00000), width: 2),
                  ),
                  selectedTextStyle: GoogleFonts.montserrat(
                    color: Color(0xFFA00000),
                    fontWeight: FontWeight.w700,
                  ),
                  defaultTextStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  todayTextStyle: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  weekendTextStyle: GoogleFonts.montserrat(
                    color: Color(0xFFA00000),
                    fontWeight: FontWeight.w700,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFFA00000),
                    shape: BoxShape.circle,
                  ),
                  markersAlignment: Alignment.bottomCenter,
                  markersMaxCount: 1,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  weekendStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA00000),
                  ),
                ),
              ),

              // Add Event Button (only for admin)
              if (_isAdmin)
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    _addEvent();
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Add a new event
  void _addEvent() {
    // Here you can navigate to a page or show a dialog to add an event
    // For now, we'll just show a simple message.
    print('Add Event button pressed!');
  }

  // Thai month names
  String _monthName(int month) {
    const monthNames = [
      '',
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
    return monthNames[month];
  }
}
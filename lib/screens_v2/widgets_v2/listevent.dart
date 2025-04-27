import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuquest/auth.dart';
import 'package:tuquest/screens_v2/addEventPage.dart';
import '../models/model.dart';
import 'post_card.dart';
import '../post_detail.dart';

class ListEventSection extends StatelessWidget {
  final DateTime selectedDate;

  const ListEventSection({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        selectedDate.day == now.day &&
        selectedDate.month == now.month &&
        selectedDate.year == now.year;

    final String displayDate =
        isToday ? 'วันนี้' : DateFormat('d MMM', 'th_TH').format(selectedDate);

    bool _isDateInRange(
      DateTime selectedDate,
      DateTime startDate,
      DateTime endDate,
    ) {
      return selectedDate.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          selectedDate.isBefore(endDate.add(const Duration(days: 1)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Date + Search bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  displayDate,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.tune, color: Colors.orange[800]),
              ],
            ),
          ),

          // Fetch events from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('events').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
              }

              final events =
                  snapshot.data?.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    DateTime? parseDate(dynamic value) {
                      if (value == null) return null;
                      if (value is Timestamp) return value.toDate();
                      if (value is String) return DateTime.tryParse(value);
                      return null;
                    }

                    return Event(
                      id: doc.id,
                      topic: data['topic'] ?? '',
                      detail: data['detail'] ?? '',
                      imageUrl: data['imageUrl'] ?? '',
                      isNetworkImage: data['isNetworkImage'] ?? true,
                      createdAt: parseDate(data['createdAt']) ?? DateTime.now(),
                      startDate: parseDate(data['startDate']) ?? DateTime.now(),
                      endDate: parseDate(data['endDate']) ?? DateTime.now(),
                    );
                  }).toList() ??
                  [];

              final filteredEvents =
                  events.where((event) {
                    return _isDateInRange(
                      selectedDate,
                      event.startDate,
                      event.endDate,
                    );
                  }).toList();

              if (filteredEvents.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'ไม่มีกิจกรรมในวันนี้',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }

              return Column(
                children:
                    filteredEvents.map((event) {
                      return PostCard(
                        post:
                            event, // assuming PostCard accepts Event (might need slight adjustment)
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PostDetailPage.fromPost(post: event),
                              ),
                            ),
                      );
                    }).toList(),
              );
            },
          ),

          // Add Event Button (only for admin)
          FutureBuilder<bool>(
            future: TQauth.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              if (snapshot.hasData && snapshot.data!) {
                return Positioned(
                  bottom: 50,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () => _addEvent(context),
                    backgroundColor: const Color(0xFFFF8000),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _addEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEventPage(selectedDate: selectedDate),
      ),
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuquest/auth.dart';
import 'package:tuquest/screens_v2/addEventPage.dart';
import '../models/model.dart';
import 'post_card.dart';
import '../post_detail.dart';

class ListEventSection extends StatefulWidget {
  final DateTime selectedDate;

  const ListEventSection({super.key, required this.selectedDate});

  @override
  State<ListEventSection> createState() => _ListEventSectionState();
}

class _ListEventSectionState extends State<ListEventSection> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query.trim().toLowerCase();
      });
    });
  }

  bool _isDateInRange(DateTime selectedDate, DateTime startDate, DateTime endDate) {
    return selectedDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        selectedDate.isBefore(endDate.add(const Duration(days: 1)));
  }

  void _addEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEventPage(selectedDate: widget.selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = widget.selectedDate.day == now.day &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.year == now.year;

    final String displayDate =
        isToday ? 'วันนี้' : DateFormat('d MMM', 'th_TH').format(widget.selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Date + Search Bar
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
                    controller: _searchController,
                    onChanged: _onSearchChanged,
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

              final events = snapshot.data?.docs.map((doc) {
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
                  creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
                );
              }).toList() ?? [];

              final searchMatches = events.where((event) {
                final matchesSearch = event.topic.toLowerCase().contains(_searchQuery) ||
                    event.detail.toLowerCase().contains(_searchQuery);
                return _searchQuery.isNotEmpty && matchesSearch;
              }).toList();

              final dayMatches = events.where((event) {
                final matchesDate = _isDateInRange(widget.selectedDate, event.startDate, event.endDate);
                final notAlreadyInSearch = !searchMatches.contains(event);
                return matchesDate && notAlreadyInSearch;
              }).toList();

              if (_searchQuery.isNotEmpty && searchMatches.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '🔍 ไม่พบกิจกรรมที่ค้นหา',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }

              if (searchMatches.isEmpty && dayMatches.isEmpty) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (searchMatches.isNotEmpty) ...[
                    ...searchMatches.map((event) => PostCard(
                          post: event,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailPage.fromPost(post: event),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'กิจกรรมในวันนี้',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (dayMatches.isNotEmpty) ...[
                    ...dayMatches.map((event) => PostCard(
                          post: event,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailPage.fromPost(post: event),
                            ),
                          ),
                        )),
                  ],
                ],
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
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      onPressed: () => _addEvent(context),
                      backgroundColor: const Color(0xFFFF8000),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
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
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuquest/auth.dart';
import 'package:tuquest/screens_v2/AddAnnouncementPage.dart';
import '../post_detail.dart';

class AnnounceCard extends StatefulWidget {
  const AnnounceCard({super.key});

  @override
  State<AnnounceCard> createState() => _AnnounceCardState();
}

class _AnnounceCardState extends State<AnnounceCard> {
  List<Map<String, dynamic>> announcements = [];
  int currentIndex = 0;
  Timer? _timer;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await TQauth.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('announcements')
              .orderBy('createdAt', descending: true)
              .get();

      final data =
          snapshot.docs.map((doc) {
            return {
              "topic": doc['topic'] ?? '',
              "description": doc['description'] ?? '',
              "picture": doc['picture'] ?? '',
              "detail": doc['detail'] ?? '',
              "id": doc.id,
            };
          }).toList();

      if (mounted) {
        setState(() {
          announcements = data;
          _isLoading = false;
          _startTimer();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (announcements.isNotEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % announcements.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDetail(BuildContext context) {
    final current = announcements[currentIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PostDetailPage(
              title: current["topic"]!,
              description: current["detail"]!,
              imageUrl: current["picture"],
              isNetworkImage: current["picture"]?.startsWith('http') ?? false,
              id: current["id"] ?? "announce_$currentIndex",
            ),
      ),
    );
  }

  void _goToAddAnnouncement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAnnouncementPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || announcements.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text(
              'No announcements available.',
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
            ),
            if (_isAdmin)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  heroTag: "add_announcement",
                  onPressed: _goToAddAnnouncement,
                  backgroundColor: const Color(0xFFFF8000),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
          ],
        ),
      );
    }

    var current = announcements[currentIndex];
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _navigateToDetail(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                if ((current["picture"] ?? '').isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  current["picture"].startsWith('http')
                                      ? NetworkImage(current["picture"])
                                      : AssetImage(current["picture"])
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              announcements.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      currentIndex == index
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current["topic"] ?? '',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current["description"] ?? '',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isAdmin)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: "add_announcement",
              onPressed: _goToAddAnnouncement,
              backgroundColor: const Color(0xFFFF8000),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuquest/screens_v2/noti_create.dart';
import 'widgets_v2/topbar.dart';
import 'widgets_v2/navbar.dart';
import 'widgets_v2/post_card.dart';
import 'models/model.dart';
import 'post_detail.dart';
import 'virtual_card.dart';

class NotiPage extends StatelessWidget {
  const NotiPage({super.key});

  // 🔵 Fetch notifications from Firestore
  Stream<List<Post>> _getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')  // assuming "notifications" is the collection name
        .orderBy('createdAt', descending: true)  // Order notifications by created time
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          topic: doc['topic'],
          detail: doc['detail'],
          imageUrl: doc['imageUrl'],
          isNetworkImage: doc['isNetworkImage'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // 🔵 Check if user is an admin
  Future<bool> _isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')  // Assuming 'users' collection
          .doc(user.uid)
          .get();

      // Check if the user document exists and has 'role' field as 'admin'
      return userDoc.exists && userDoc.data()?['role'] == 'admin';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: const CustomTopBar(),

      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity! > 300) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VirtualCardPage(
                  onBackToTop: () => Navigator.pop(context),
                ),
              ),
            );
          }
        },
        child: Container(
          color: const Color(0xFFFF9D00),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // White Container
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "การแจ้งเตือน",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Notification List
                      Expanded(
                        child: StreamBuilder<List<Post>>(
                          stream: _getNotifications(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'ไม่มีการแจ้งเตือน',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              );
                            }

                            final notifications = snapshot.data!;

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final post = notifications[index];
                                return Column(
                                  children: [
                                    PostCard(
                                      post: post,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PostDetailPage.fromPost(post: post),
                                        ),
                                      ),
                                    ),
                                    if (index != notifications.length - 1)
                                      const SizedBox(height: 12),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                                    FutureBuilder<bool>(
                future: _isAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Loading state, no button
                  }

                  if (snapshot.hasData && snapshot.data!) {
                    // Display the '+' button for admins
                    return Positioned(
                      bottom: 50,
                      right: 0,
                      child: FloatingActionButton(
                        onPressed: () {
                          // Navigate to the admin notification page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminNotiPage()),  // Replace with actual page
                          );
                        },
                        backgroundColor: const Color(0xFFFF8000),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  return const SizedBox(); // If not admin, no button
                },
              ),
                    ],
                  ),
                  
                ),
              ),
              // Admin Check and Floating Button

            ],
          ),
        ),
      ),
    );
  }
}

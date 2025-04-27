import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuquest/auth.dart';
import 'package:tuquest/screens_v2/noti_create.dart';
import 'widgets_v2/topbar.dart';
import 'widgets_v2/post_card.dart';
import 'models/model.dart';
import 'post_detail.dart';

class NotiPage extends StatelessWidget {
  const NotiPage({super.key});
  // 🔵 Fetch notifications from Firestore
  Stream<List<Post>> _getNotifications() {
    return FirebaseFirestore.instance
        .collection(
          'notifications',
        ) // assuming "notifications" is the collection name
        .orderBy(
          'createdAt',
          descending: true,
        ) // Order notifications by created time
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
              creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
            );
          }).toList();
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: const CustomTopBar(),

      body: GestureDetector(
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFFF9D00),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final post = notifications[index];
                                    return Column(
                                      children: [
                                        PostCard(
                                          post: post,
                                          onTap:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          PostDetailPage.fromPost(
                                                            post: post,
                                                          ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 🔥 Floating button placed correctly inside Stack
            FutureBuilder<bool>(
              future: TQauth.isAdmin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.hasData && snapshot.data!) {
                  return Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminNotiPage(),
                          ),
                        );
                      },
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
      ),
    );
  }
}

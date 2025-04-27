import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'widgets_v2/topbar.dart';
import 'providers/fav_provider.dart';
import 'models/model.dart';
import 'widgets_v2/navbar.dart';
import 'virtual_card.dart';

class PostDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final bool isNetworkImage;
  final DateTime? createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? id;

  const PostDetailPage({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.isNetworkImage = true,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.id,
  });

  /// Smart constructor from Post or Event
  factory PostDetailPage.fromPost({
    Key? key,
    required Post post,
  }) {
    if (post is Event) {
      return PostDetailPage(
        key: key,
        title: post.topic,
        description: post.detail,
        imageUrl: post.imageUrl,
        isNetworkImage: post.isNetworkImage,
        createdAt: post.createdAt,
        startDate: post.startDate,
        endDate: post.endDate,
        id: post.id,
      );
    } else {
      return PostDetailPage(
        key: key,
        title: post.topic,
        description: post.detail,
        imageUrl: post.imageUrl,
        isNetworkImage: post.isNetworkImage,
        createdAt: post.createdAt,
        id: post.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavProvider>(context);
    final post = _toPost();

    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: const CustomTopBar(),
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity! > 200) {
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
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "รายละเอียดโพสต์",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF8000),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      favProvider.isFavorite(post)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favProvider.isFavorite(post)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (favProvider.isFavorite(post)) {
                                        favProvider.remove(post);
                                      } else {
                                        favProvider.add(post);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (imageUrl?.isNotEmpty ?? false)
                                _buildImageWidget(),

                              const SizedBox(height: 16),

                              Text(
                                title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (createdAt != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "วันที่โพสต์: ${DateFormat('d MMM yyyy', 'th_TH').format(createdAt!)}",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],

                              if (startDate != null && endDate != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "เริ่ม: ${DateFormat('d MMM yyyy', 'th_TH').format(startDate!)}",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  "สิ้นสุด: ${DateFormat('d MMM yyyy', 'th_TH').format(endDate!)}",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),

                              Text(
                                description,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: Text(
                              'ย้อนกลับ',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: isNetworkImage
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            )
          : Image.asset(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
    );
  }

  Post _toPost() {
    if (startDate != null && endDate != null) {
      return Event(
        id: id ?? DateTime.now().toIso8601String(),
        topic: title,
        detail: description,
        imageUrl: imageUrl ?? '',
        isNetworkImage: isNetworkImage,
        createdAt: createdAt ?? DateTime.now(),
        startDate: startDate!,
        endDate: endDate!,
        creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
      );
    } else {
      return Post(
        id: id ?? DateTime.now().toIso8601String(),
        topic: title,
        detail: description,
        imageUrl: imageUrl ?? '',
        isNetworkImage: isNetworkImage,
        createdAt: createdAt ?? DateTime.now(),
        creatorUID: FirebaseAuth.instance.currentUser?.uid ?? '',
      );
    }
  }
}

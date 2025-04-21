import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final String title;
  final String message;
  final String? imagePath;
  final String? imagePathTwo;

  const AnnouncementDetailPage({
    Key? key,
    required this.title,
    required this.message,
    this.imagePath,
    this.imagePathTwo,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcement Details')),
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imagePath != null && imagePath!.isNotEmpty
                ? Image.network(
                    imagePath!,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => SizedBox(),
                  )
                : SizedBox(),
                const SizedBox(height: 8),
                imagePathTwo != null && imagePathTwo!.isNotEmpty
                ? Image.network(
                    imagePathTwo!,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => SizedBox(),
                  )
                : SizedBox(),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          ),
        ],
        ),
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
}

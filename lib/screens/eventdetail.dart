import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuquest/widgets/bottom_nav.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, String> eventData;

  const EventDetailScreen({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Detail",
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
            child: Card(
              color: Colors.orange.shade300,
              child: Column(
                children: [
                  Text("${eventData['title']}", style: _titleTextStyle()),
                  Image.asset(eventData["image"]!, height: 150, fit: BoxFit.cover),
                  Text(eventData["time"]!, style: _infoTextStyle()),
                  Text(eventData["location"]!, style: _infoTextStyle()),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(eventData["description"]!, style: _descTextStyle()),
                  ),
                ],
              ),
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

  TextStyle _titleTextStyle() => GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _infoTextStyle() => GoogleFonts.montserrat(fontSize: 16, color: Colors.white);
  TextStyle _descTextStyle() => GoogleFonts.montserrat(fontSize: 14, color: Colors.white);
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuquest/widgets/bottom_nav.dart';

class TualertPage extends StatelessWidget {
  const TualertPage({super.key});
 

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
                "TUAlert",
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
        ]
        
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

  Widget _buildAlertCard(String image, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(title, style: GoogleFonts.montserrat(color: Colors.white)),
                ),
                const SizedBox(height: 5),
                Text(desc, style: GoogleFonts.montserrat(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle() {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}
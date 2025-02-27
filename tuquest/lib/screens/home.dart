import 'package:flutter/material.dart';
import 'tualert.dart';
import 'eventboard.dart';
import 'questboard.dart';
import 'package:tuquest/widgets/bottom_nav.dart'; // เรียกใช้ Bottom Navigation
 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFFFF0004),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // โลโก้ QuestBoard พร้อม Gradient
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFA00000), Color(0xFFEA2520), Color(0xFFFF8000)],
                    stops: [0.01, 0.52, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: const Text(
                  'QuestBoard',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
 
              const SizedBox(height: 40),
 
              // ปุ่ม TUAlert
              _buildButton(context, "TUAlert", const TualertPage()),
 
              const SizedBox(height: 20),
 
              // ปุ่ม Event
              _buildButton(context, "Event", const EventBoardPage()),
 
              const SizedBox(height: 20),
 
              // ปุ่ม Quest
              _buildButton(context, "Quest", const QuestBoardPage()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(), // ใช้ Widget Bottom Navigation
    );
  }
 
  // ฟังก์ชันสร้างปุ่ม
  Widget _buildButton(BuildContext context, String text, Widget targetPage) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
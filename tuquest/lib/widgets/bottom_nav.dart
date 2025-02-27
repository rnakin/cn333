import 'package:flutter/material.dart';
import 'package:tuquest/screens/home.dart';
import 'package:tuquest/screens/chatboard.dart';
import 'package:tuquest/screens/createpost.dart';
import 'package:tuquest/screens/notification.dart';
import 'package:tuquest/screens/account.dart';
 
class BottomNav extends StatelessWidget {
  const BottomNav({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF8000), // สีพื้นหลังของ Navigation Bar
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context, Icons.home, "Home", const HomeScreen()),
          _buildNavItem(context, Icons.chat, "Chat", const ChatBoardPage()),
 
          // ปุ่มตรงกลาง (Create Post)
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
            },
            backgroundColor: Colors.orange,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
 
          _buildNavItem(context, Icons.notifications, "Notice", const NotificationPage()),
          _buildNavItem(context, Icons.person, "Account", const AccountPage()),
        ],
      ),
    );
  }
 
  // ฟังก์ชันสร้างปุ่มใน Navigation Bar
  Widget _buildNavItem(BuildContext context, IconData icon, String label, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
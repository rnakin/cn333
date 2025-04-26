import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';
import 'contact.dart';
import 'login.dart';
import 'widgets_v2/topbar.dart';
import 'package:tuquest/auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Mock Data สำหรับผู้ใช้
  final Map<String, dynamic> _userData = {
    'name': 'สมศักดิ์ สมชาย',
    'studentId': '6510615999',
    'profileImageUrl':
        'https://i.pinimg.com/564x/5e/b5/5e/5eb55ec2482b119c9bb8a207d255b07e.jpg',
    'isNotificationOn': true,
    'language': 'TH',
  };

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedImage != null) {
      setState(() {
        _userData['profileImageUrl'] = pickedImage.path;
      });
    }
  }

  void _changeLanguage(String lang) {
    setState(() {
      _userData['language'] = lang;
    });
  }

  void _toggleNotification(bool value) {
    setState(() {
      _userData['isNotificationOn'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      body: Column(
        children: [
          const CustomTopBar(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chevron_left,
                        color: Color(0xFFA00000),
                        size: 32,
                      ),
                      Text(
                        "Back",
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFA00000),
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.help_outline,
                  color: Color(0xFFD55757),
                  size: 32,
                ),
              ],
            ),
          ),

          // ส่วนแสดงรูปโปรไฟล์
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 85,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 78,
                  backgroundImage:
                      _userData['profileImageUrl'] != null &&
                              !_userData['profileImageUrl']
                                  .toString()
                                  .startsWith('http')
                          ? Image.file(File(_userData['profileImageUrl'])).image
                          : NetworkImage(_userData['profileImageUrl'])
                              as ImageProvider,
                ),
              ),
              Positioned(
                bottom: 7,
                right: 7,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.edit, size: 20, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ส่วนแสดงข้อมูลผู้ใช้จาก Mock Data
          Text(
            _userData['name'],
            style: GoogleFonts.montserrat(
              color: const Color(0xFFA00000),
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Student ID: ${_userData['studentId']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          // ส่วนเมนู
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(38),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTile(
                    icon: Icons.person,
                    title: "Profile",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        ),
                  ),
                  const SizedBox(height: 18),

                  _buildLanguageToggle(),
                  const SizedBox(height: 18),

                  _buildNotificationToggle(),
                  const SizedBox(height: 18),

                  _buildTile(
                    icon: Icons.mail,
                    title: "Contact us",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ContactPage(),
                          ),
                        ),
                  ),

                  const Spacer(),

                  // ปุ่ม Logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        bool isLoading = true;
                        bool result = false;

                        try {
                          result = await TQauth.logout();
                        } catch (e) {
                          // Optionally handle the error, e.g., show a snackbar
                        } finally {
                          isLoading = false;
                        }

                        if (result == true) {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
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
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Color(0xFFFF9D00),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFFA00000),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Color(0xFFA00000),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLanguageToggle() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFF9D00),
        child: Icon(Icons.language, color: Colors.white),
      ),
      title: const Text(
        "Language",
        style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFA00000)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: ["TH", "EN"].map((lang) => _langToggle(lang)).toList(),
      ),
    );
  }

  Widget _langToggle(String lang) {
    final isSelected = lang == _userData['language'];
    return GestureDetector(
      onTap: () => _changeLanguage(lang),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF9D00) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          lang,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFF9D00),
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: const Text(
        "Notifications",
        style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFA00000)),
      ),
      trailing: Switch(
        value: _userData['isNotificationOn'],
        activeColor: Color(0xFFFF9D00),
        onChanged: _toggleNotification,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'edit.dart';
import 'package:tuquest/widgets/bottom_nav.dart';
import 'contact.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;

  final picker = ImagePicker();

  bool isEnglish = true; // ค่าเริ่มต้นของภาษา (EN)

  // ฟังก์ชันเลือกภาพโปรไฟล์

  Future<void> _pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

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

            colors: [Color(0xFF000000), Color(0xFFFF0004)],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          child: Column(
            children: [
              // Header "Profile"
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFA00000),
                      Color(0xFFEA2520),
                      Color(0xFFFF8000),
                    ],

                    stops: [0.01, 0.52, 1.0],
                  ).createShader(bounds);
                },

                blendMode: BlendMode.srcIn,

                child: const Text(
                  'Profile',

                  style: TextStyle(
                    fontSize: 36,

                    fontWeight: FontWeight.bold,

                    fontFamily: 'Montserrat',

                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // โปรไฟล์รูปภาพ
              Stack(
                alignment: Alignment.bottomRight,

                children: [
                  CircleAvatar(
                    radius: 50,

                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                  ),

                  GestureDetector(
                    onTap: _pickProfileImage,

                    child: CircleAvatar(
                      radius: 15,

                      backgroundColor: Colors.orange,

                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Sheldon1",

                style: TextStyle(
                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 20),

              // Edit Profile
              _buildMenuItem(Icons.person, "Edit Profile", () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              }),

              // Language Toggle
              _buildLanguageToggle(),

              // Notifications
              _buildToggleItem(Icons.notifications, "Notifications", true),
              //_buildButton(context, "Event", const EventBoardPage()),
              // Contact Us
              _buildMenuItem(Icons.mail, "Contact us", () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );  
              }),
                
              const SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged out successfully!")),
                    );
                  },

                  icon: const Icon(Icons.logout, color: Colors.white),

                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }

  // ฟังก์ชันสร้างเมนู (Edit Profile, Contact Us)

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 30),

      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),

      onTap: onTap,
    );
  }

  // Toggle Language (EN / TH)

  Widget _buildLanguageToggle() {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.orange, size: 30),

      title: const Text(
        "Language",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),

      trailing: ToggleButtons(
        borderRadius: BorderRadius.circular(20),

        selectedColor: Colors.black,

        fillColor: Colors.orange,

        color: Colors.white,

        constraints: const BoxConstraints(minWidth: 50, minHeight: 30),

        isSelected: [!isEnglish, isEnglish],

        onPressed: (index) {
          setState(() {
            isEnglish = index == 1;
          });
        },

        children: const [Text("TH"), Text("EN")],
      ),
    );
  }

  // Toggle (Notifications)

  Widget _buildToggleItem(IconData icon, String text, bool defaultValue) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 30),

      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),

      trailing: Switch(
        value: defaultValue,

        onChanged: (bool value) {},

        activeColor: Colors.orange,
      ),
    );
  }
}

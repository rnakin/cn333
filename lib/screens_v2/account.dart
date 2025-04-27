import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

import 'contact.dart';
import 'login.dart';
import 'profile.dart';
import 'widgets_v2/topbar.dart';
import 'package:tuquest/auth.dart';

/// A simple user model to hold account information.
class User {
  String name;
  String studentId;
  String? profileImagePath;
  bool notificationsEnabled;
  String language;

  User({
    required this.name,
    required this.studentId,
    this.profileImagePath,
    this.notificationsEnabled = true,
    this.language = 'TH',
  });
}

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User _currentUser = User(
    name: 'สมศักดิ์ สมชาย',
    studentId: '6510615999',
    // Default network image
    profileImagePath:
        'https://i.pinimg.com/564x/5e/b5/5e/5eb55ec2482b119c9bb8a207d255b07e.jpg',
  );

  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and updates the user profile picture.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      setState(() {
        _currentUser.profileImagePath = pickedFile.path;
      });
    }
  }

  /// Updates selected language.
  void _changeLanguage(String lang) {
    setState(() => _currentUser.language = lang);
  }

  /// Toggles notification setting.
  void _toggleNotification(bool enabled) {
    setState(() => _currentUser.notificationsEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      body: Column(
        children: [
          const CustomTopBar(),
          _buildHeader(context),
          Expanded(
            child: _buildMenuSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _backButton(context),
              const Icon(Icons.help_outline, color: Color(0xFFD55757), size: 32),
            ],
          ),
          const SizedBox(height: 20),
          _profileAvatar(),
          const SizedBox(height: 20),
          Text(
            _currentUser.name,
            style: GoogleFonts.montserrat(
              color: const Color(0xFFA00000),
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Student ID: ${_currentUser.studentId}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          const Icon(Icons.chevron_left, color: Color(0xFFA00000), size: 32),
          Text(
            'Back',
            style: GoogleFonts.montserrat(
              color: const Color(0xFFA00000),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileAvatar() {
    final isLocal = _currentUser.profileImagePath != null &&
        !_currentUser.profileImagePath!.startsWith('http');
    final imageProvider = isLocal
        ? FileImage(File(_currentUser.profileImagePath!))
        : NetworkImage(_currentUser.profileImagePath!) as ImageProvider;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 85,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 78,
            backgroundImage: imageProvider,
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
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
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
            title: 'Profile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          const SizedBox(height: 18),
          LanguageToggle(
            currentLang: _currentUser.language,
            onChanged: _changeLanguage,
          ),
          const SizedBox(height: 18),
          NotificationToggle(
            enabled: _currentUser.notificationsEnabled,
            onChanged: _toggleNotification,
          ),
          const SizedBox(height: 18),
          _buildTile(
            icon: Icons.mail,
            title: 'Contact us',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactPage()),
            ),
          ),
          const Spacer(),
          _logoutButton(context),
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
        backgroundColor: const Color(0xFFFF9D00),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFFA00000),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFFA00000)),
      onTap: onTap,
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          final result = await TQauth.logout().catchError((_) => false);
          if (result && context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

/// A widget to toggle between TH and EN languages.
class LanguageToggle extends StatelessWidget {
  final String currentLang;
  final ValueChanged<String> onChanged;

  const LanguageToggle({
    Key? key,
    required this.currentLang,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFF9D00),
        child: Icon(Icons.language, color: Colors.white),
      ),
      title: const Text(
        'Language',
        style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFA00000)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['TH', 'EN'].map((lang) {
          final bool isSelected = lang == currentLang;
          return GestureDetector(
            onTap: () => onChanged(lang),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF9D00) : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                lang,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A widget containing a switch to enable or disable notifications.
class NotificationToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const NotificationToggle({
    Key? key,
    required this.enabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFF9D00),
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFA00000)),
      ),
      trailing: Switch(
        value: enabled,
        activeColor: const Color(0xFFFF9D00),
        onChanged: onChanged,
      ),
    );
  }
}

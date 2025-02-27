import 'package:flutter/material.dart';

import 'package:tuquest/widgets/bottom_nav.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Header
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
                  'Edit Profile',

                  style: TextStyle(
                    fontSize: 36,

                    fontWeight: FontWeight.bold,

                    fontFamily: 'Montserrat',

                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ฟอร์มกรอกข้อมูล
              _buildTextField("Username", "Sheldon1"),

              _buildTextField("Name", "Sheldon Cooper"),

              _buildTextField("E-mail", "shelly1_cc@gmail.com"),

              _buildTextField("Password", "**********", isPassword: true),

              const SizedBox(height: 20),

              // ปุ่ม Save
              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),

                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
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

  Widget _buildTextField(
    String label,
    String value, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(label, style: const TextStyle(color: Colors.white)),

        TextField(
          obscureText: isPassword,

          decoration: InputDecoration(filled: true, fillColor: Colors.orange),
        ),
      ],
    );
  }
}

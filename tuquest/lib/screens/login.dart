import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';
import 'signup.dart';
import 'reset_password.dart';
import 'phone_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false; // ควบคุมการแสดงรหัสผ่าน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFFFF0004)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // โลโก้แอป
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFA00000), Color(0xFFEA2520), Color(0xFFFF8000)],
                    ).createShader(bounds),
                    child: Text(
                      "TUQuest",
                      style: GoogleFonts.montserrat(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ช่องกรอก Username
                  _buildInputLabel("Username"),
                  _buildTextField(label: "Enter username", obscureText: false),

                  const SizedBox(height: 15),

                  // ช่องกรอก Password
                  _buildInputLabel("Password"),
                  _buildTextField(label: "Enter password", obscureText: true),

                  const SizedBox(height: 20),

                  // ปุ่ม Login
                  _buildButton(
                    text: "Login",
                    color: const Color(0xFFFF8000),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // ลิงก์ Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                        );
                      },
                      child: const Text(
                        'Forgot Your Password?',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF8000)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // เส้นแบ่ง OR
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white, thickness: 1.5, endIndent: 10)),
                      Text("OR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Expanded(child: Divider(color: Colors.white, thickness: 1.5, indent: 10)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ปุ่ม Login with Google
                  _buildButton(
                    text: "Login with Google",
                    color: Colors.white,
                    textColor: Colors.black,
                    icon: "assets/google_logo.png",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login with Google is not implemented yet")),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // ปุ่ม Login with Phone
                  _buildButton(
                    text: "Login with phone number",
                    color: Colors.white,
                    textColor: Colors.black,
                    iconData: Icons.phone,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PhoneLoginPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // ลิงก์ Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: Color(0xFFFF8000))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF8000)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง Label
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างช่องกรอกข้อมูล
  Widget _buildTextField({required String label, required bool obscureText}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextField(
        obscureText: obscureText ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างปุ่ม
  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    String? icon,
    IconData? iconData,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Image.asset(icon, height: 24)
            : Icon(iconData, color: textColor),
        label: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

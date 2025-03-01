import 'package:flutter/material.dart';
 
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: const Color(0xFFA00000), // สีตามธีมแอป
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email to receive a password reset link.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
 
            // ช่องกรอกอีเมล
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
 
            const SizedBox(height: 20),
 
            // ปุ่มส่งอีเมลรีเซ็ต
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password reset link sent!")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8000), // สีปุ่มตามดีไซน์
                minimumSize: const Size(300, 50),
              ),
              child: const Text("Send Reset Link", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
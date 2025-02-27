import 'package:flutter/material.dart';
 
class PhoneLoginPage extends StatelessWidget {
  const PhoneLoginPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Login"),
        backgroundColor: const Color(0xFFA00000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your phone number to receive an OTP.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
 
            // ช่องกรอกเบอร์โทรศัพท์
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
 
            const SizedBox(height: 20),
 
            // ปุ่มส่ง OTP
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("OTP Sent to your phone!")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8000),
                minimumSize: const Size(300, 50),
              ),
              child: const Text("Send OTP", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
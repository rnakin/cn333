import 'package:flutter/material.dart';
import 'home.dart'; // ลิงก์ไปยังหน้า home
 
class HomePage extends StatelessWidget {
  const HomePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // ✅ ทำให้พื้นหลังเต็มจอ
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
        child: Center( // ✅ ใช้ Center เพื่อจัด UI ให้อยู่ตรงกลาง
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // โลโก้ TUQuest พร้อม Gradient
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFA00000), Color(0xFFEA2520), Color(0xFFFF8000)],
                    stops: [0.01, 0.52, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn, // ✅ แก้ปัญหา ShaderMask สีจาง
                child: const Text(
                  'TUQuest',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
 
              const SizedBox(height: 20),
 
              // รูป Quest Board พร้อมคลิกเพื่อไปหน้า HomeScreen
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: Center( // ✅ จัดรูปภาพให้อยู่กึ่งกลาง
                  child: Image.asset(
                    'assets/questboard.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Image not found!", style: TextStyle(color: Colors.red));
                    },
                  ),
                  ),
                ),
 
              const SizedBox(height: 20),
 
              // ข้อความ Click on the board
              const Text(
                "Click on the board to update\nnews and quest",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
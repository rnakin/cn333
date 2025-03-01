import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 166, 35, 39),
        ),
      ),
      home: const SplashPage(), 
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // เปลี่ยนไปหน้า login หลัง 5 วิ
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Text(
            "TUQuest",
            style: GoogleFonts.montserrat(
              fontSize: 48,
              fontWeight: FontWeight.w800, // ExtraBold
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFFA00000),
                    Color(0xFFEA2520),
                    Color(0xFFFF8000),
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'pages/calendar_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Calendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalendarPage(),
    );
  }
}

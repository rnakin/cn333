import 'dart:async'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_option.dart';
import 'login.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Quest',
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash extends StatefulWidget {
  const Splash ({super.key});
  @override
  _Splash  createState() => _Splash ();
}

class _Splash  extends State<Splash > {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 1500),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: "Splash",
      home: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 183, 10, 10),
                  const Color.fromARGB(255, 0, 0, 0),
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
              ),
            ),
            child: Center(
              child: Image.asset(
                'image/tuquest_icon.png', //name
                width: screenWidth * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 183, 10, 10),
                  const Color.fromARGB(255, 0, 0, 0),
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
              ),
            ),
            child: Center(
              child: SignInPage()
              ),
            ),
          ),
        );
  }
}

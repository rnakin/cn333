import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 183, 10, 10),
                  const Color.fromARGB(255, 0, 0, 0),
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),

      );
  }
}


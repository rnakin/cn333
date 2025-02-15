import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity, 
            height:  double.infinity, 
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
                  'image/tuquest_icon.png',//name
                   width: screenWidth*0.5,

                  ),
            ),
          ),
        ),
      ),
    );
  }
}

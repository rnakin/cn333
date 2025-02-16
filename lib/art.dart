import 'package:flutter/material.dart';


class RedBlackGradientBox extends StatelessWidget {
  const RedBlackGradientBox ({super.key});
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
              //Your content here
              ),
            ),
          ),
        );
  }
}
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:tuquest/widgets/profile_widget.dart';
class ChatRoomsPage extends StatelessWidget {
  const ChatRoomsPage({super.key});

  @override
  Widget build(BuildContext context) {

    if (FirebaseAuth.instance.currentUser == null)  {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        ),
      );
      return const SizedBox(); // Return empty widget 
    }

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(25), child: ChatProfileBar()),
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
            child: Column(
              children: [
                Text("your are now in chat room page"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 255),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("return"),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
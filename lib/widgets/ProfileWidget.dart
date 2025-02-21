import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuquest/pages/homepage.dart';
class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is signed in
    if (user == null) {
      return const Center(child: Text("No user logged in"));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile Picture
        CircleAvatar(
          radius: 50, // Size of profile picture
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!) // Load profile image from Firebase
              : const AssetImage("assets/default_profile.png") as ImageProvider, // Default profile image
        ),
        const SizedBox(height: 10),

        // Display user email
        Text(
          user.email ?? "No Email",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
class ProfileWidgetBar extends StatelessWidget {
  const ProfileWidgetBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[400], 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Return Arrow Button
          IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
          })
,
          // Profile Picture
          CircleAvatar(
            radius: 20, // Smaller profile size for bar
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage("assets/default_profile.png") as ImageProvider,
          ),

          //Email Display
          Expanded(
            child: Text(
              user?.email ?? "No Email",
              style: const TextStyle(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),

          //Phone Call Icon (Mockup)
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {}, // Not functional yet
          ),

          //Video Call Icon (Mockup)
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {}, // Not functional yet
          ),
        ],
      ),
    );
  }
}
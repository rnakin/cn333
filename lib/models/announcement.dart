import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String title; 
  final String message;
  final Timestamp timestamp;
  String? imagePath;
  String? imagePathTwo;

  Announcement({
    required this.message,
    required this.title,
    required this.timestamp,
    this.imagePath,
    this.imagePathTwo,
  });

  // Factory to create from Firestore
  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      message: map['message'] ?? '',
      title: map['title'] ?? 'info',
      timestamp: map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
      imagePath: map['imagePath'] ?? '',
      imagePathTwo: map['imagePathTwo'] ?? '',
    );
  }

  // Optional: To convert back to map
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'title': title,
      'timestamp': timestamp,
      'imagePath': imagePath,
      'imagePathTwo': imagePathTwo,
    };
  }

  static Future<void> addAnnounce(String title, String message, {String? imagePath, String? imagePathTwo}) async {
  final db = FirebaseFirestore.instance;
  final annouceRef = db.collection('announcements').doc(); // gen id

  Announcement newAnnounce = Announcement(
    title: title,
    message: message,
    imagePath: imagePath,
    imagePathTwo: imagePathTwo,
    timestamp: Timestamp.now(),
  );

  await annouceRef.set(newAnnounce.toMap());
}
}

// Announcement copyWith({
//     String? title,
//     String? message,
//     String? imagePath,
//     Timestamp? timestamp,
//   }) {
//     return Quest(
//       id: id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       imagePath: imagePath ?? this.imagePath,
//       timestamp: timestamp ?? this.timestamp,
//     );}

// factory Quest.fromMap(Map<String, dynamic> map, String documentId) {
//   return Quest(
//     title: map['title'] ?? 'Untitled Quest',
//     timestamp: map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
//     description: map['description'] ?? 'No description available',
//     imagePath: map['imagePath'] ?? '',
//   );
// }




// import 'dart:ui';

// import 'package:flutter/material.dart';

// class Announcement {
//   final String message;
//   final IconData icon;
//   final Color backgroundColor;
//   final Color textColor;
//   String? imagePath;

//   Announcement({
//     required this.message,
//     required this.type,
//     required this.title,
//     required this.timestamp,
//     this.imagePath,
//   });

//   const AnnouncementBox({
//     Key? key,
//     required this.message,
//     this.icon = Icons.announcement,
//     this.backgroundColor = const Color(0xFFEDF2FA),
//     this.textColor = Colors.black87,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: backgroundColor,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Icon(icon, color: textColor),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(fontSize: 16, color: textColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

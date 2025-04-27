import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminNotiPage extends StatefulWidget {
  const AdminNotiPage({super.key});

  @override
  _AdminNotiPageState createState() => _AdminNotiPageState();
}

class _AdminNotiPageState extends State<AdminNotiPage> {
  final _topicController = TextEditingController();
  final _detailController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  // Function to upload the selected image to Firebase Storage
  Future<String> _uploadImage() async {
    if (_image == null) {
      throw Exception('No image selected');
    }
    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('notifications/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(File(_image!.path));

      // Get image URL after upload
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

void _submitNotification() async {
  final topic = _topicController.text;
  final detail = _detailController.text;

  // Check if topic is empty, as it is required
  if (topic.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please provide a topic')),
    );
    return;
  }

  try {
    String? imageUrl;

    // If an image is selected, upload it and get the URL
    if (_image != null) {
      imageUrl = await _uploadImage();
    }

    // Add the notification to Firestore
    await FirebaseFirestore.instance.collection('notifications').add({
      'topic': topic,
      'detail': detail.isNotEmpty ? detail : 'No description provided',
      'imageUrl': imageUrl ?? '',  // Use an empty string if no image is provided
      'isNetworkImage': imageUrl != null,
      'createdAt': Timestamp.now(),
    });

    // Clear the input fields and reset image selection
    _topicController.clear();
    _detailController.clear();
    setState(() {
      _image = null;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification sent successfully')),
    );
  } catch (e) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: AppBar(
        title: Text(
          "ส่งการแจ้งเตือน",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF8000),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFFFF8000),
        child: SizedBox(height: 50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "เพิ่มการแจ้งเตือน",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF8000),
                  ),
                ),
              ),

              // Topic Input
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: "หัวข้อการแจ้งเตือน",
                  labelStyle: GoogleFonts.montserrat(
                    color: Color(0xFFFF8000),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFF8000)),
                  ),
                ),
                style: GoogleFonts.montserrat(),
              ),
              const SizedBox(height: 12),

              // Detail Input
              TextField(
                controller: _detailController,
                decoration: InputDecoration(
                  labelText: "รายละเอียดการแจ้งเตือน",
                  labelStyle: GoogleFonts.montserrat(
                    color: Color(0xFFFF8000),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFF8000)),
                  ),
                ),
                maxLines: 4,
                style: GoogleFonts.montserrat(),
              ),
              const SizedBox(height: 12),

              // Image Picker Button
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: Text(
                  'เลือกรูปภาพ',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Display selected image
              if (_image != null) ...[
                Image.file(
                  File(_image!.path),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
              ],

              // Submit Button
              ElevatedButton(
                onPressed: _submitNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: Text(
                  'ส่งการแจ้งเตือน',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

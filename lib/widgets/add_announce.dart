import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuquest/models/announcement.dart';
import 'dart:io';

class AddAnnouncePage extends StatefulWidget {
  @override
  _AddAnnouncePageState createState() => _AddAnnouncePageState();
}

class _AddAnnouncePageState extends State<AddAnnouncePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _imgPathController = TextEditingController();
  final TextEditingController _imgPathControllerTwo = TextEditingController();
  // File? _image;

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  void _createAnnouncement() async {
    if (_titleController.text.isNotEmpty && _messageController.text.isNotEmpty) {
      await Announcement.addAnnounce(
        _titleController.text,
        _messageController.text,
        imagePath: _imgPathController.text.isNotEmpty ? _imgPathController.text : null,
        imagePathTwo: _imgPathControllerTwo.text.isNotEmpty ? _imgPathControllerTwo.text : null,
      );

      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide both a title and a message.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create an Announcement')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _imgPathController,
              decoration: InputDecoration(labelText: 'Image URL (optional)'),
              onChanged: (_) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            if (_imgPathController.text.isNotEmpty) // <-- Conditionally show second TextField
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                controller: _imgPathControllerTwo,
                decoration: InputDecoration(labelText: 'Second Image URL (optional)'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _createAnnouncement, child: Text('Create')),
          ],
        ),
      ),
    );
  }
}

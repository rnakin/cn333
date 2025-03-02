import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "package:tuquest/models/quest.dart";
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:uuid/uuid.dart';

class AddQuestPage extends StatefulWidget {
  @override
  _AddQuestPageState createState() => _AddQuestPageState();
}

class _AddQuestPageState extends State<AddQuestPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

void _submitQuest() async {
  if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
    await Quest.addQuest(
      _titleController.text,
      _descriptionController.text,
      imagePath: _image?.path, // Pass image path if available
    );

    Navigator.pop(context,true); // Go back to Quest Page
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please provide both a title and a description.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Quest')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Quest Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Quest Description'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 150)
                : Text("No image selected"),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text("Select Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submitQuest, child: Text('Add Quest')),
          ],
        ),
      ),
    );
  }
}

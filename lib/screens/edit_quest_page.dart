import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "package:tuquest/models/quest.dart";

class EditQuestPage extends StatefulWidget {
  final Quest quest;

  EditQuestPage({required this.quest});

  @override
  _EditQuestPageState createState() => _EditQuestPageState();
}

class _EditQuestPageState extends State<EditQuestPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quest.title);
    _descriptionController = TextEditingController(
      text: widget.quest.description,
    );
    if (widget.quest.imagePath != null && widget.quest.imagePath!.isNotEmpty) {
  _image = File(widget.quest.imagePath!);
}
  }

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

 void _saveChanges() {
  if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
    // Create an updated Quest using copyWith to update only the changed fields.
    Quest updatedQuest = widget.quest.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      imagePath: _image?.path ?? widget.quest.imagePath, // Keep old image if not changed.
      // Optionally update timestamp: timestamp: Timestamp.now(),
    );

    // Pop with the updated quest so the previous page can refresh its data.
    Navigator.pop(context, updatedQuest);
  } else {
    // Optionally, show a snackbar if fields are empty.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Quest')),
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
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

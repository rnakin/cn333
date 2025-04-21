import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditEventPage extends StatefulWidget {
  final String? eventId;
  final String? initialTitle;
  final String? initialDescription;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final String? initialImageUrl;
  final String? initialImageFilePath;
  final void Function({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    String? imageUrl,
    String? imageFilePath,
  }) onSave;

  const AddEditEventPage({
    super.key,
    this.eventId,
    this.initialTitle,
    this.initialDescription,
    this.initialStart,
    this.initialEnd,
    this.initialImageUrl,
    this.initialImageFilePath,
    required this.onSave, required String currentUserId,
  });

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _imageUrlController;
  DateTime? _startDate;
  DateTime? _endDate;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
    _imageUrlController = TextEditingController(text: widget.initialImageUrl);
    _startDate = widget.initialStart ?? DateTime.now();
    _endDate = widget.initialEnd ?? DateTime.now().add(const Duration(hours: 1));
  }

  Future<void> _pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _imageUrlController.clear();
      });
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate! : _endDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startDate! : _endDate!),
    );

    if (time == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startDate = dateTime;
      } else {
        _endDate = dateTime;
      }
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        title: _titleController.text,
        description: _descController.text,
        start: _startDate!,
        end: _endDate!,
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
        imageFilePath: _pickedImage?.path,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageToShow = _pickedImage != null
        ? Image.file(_pickedImage!, height: 200)
        : (_imageUrlController.text.isNotEmpty
            ? Image.network(_imageUrlController.text, height: 200)
            : null);

    return Scaffold(
      appBar: AppBar(title: Text(widget.eventId == null ? 'Add Event' : 'Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Start: ${_startDate.toString().substring(0, 16)}'),
                      onTap: () => _pickDateTime(isStart: true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('End: ${_endDate.toString().substring(0, 16)}'),
                      onTap: () => _pickDateTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Pick from Gallery"),
                onPressed: _pickImageFromGallery,
              ),
              if (imageToShow != null) imageToShow,
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Event'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

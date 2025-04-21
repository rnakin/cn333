import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event_model.dart';

class AddEditEventPage extends StatefulWidget {
  final EventModel? event;
  final Future<void> Function({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    String? imageUrl,
  }) onSave;

  const AddEditEventPage({
    super.key,
    this.event,
    required this.onSave,
  });

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.event?.imageUrl ?? '');
    _startDate = widget.event?.startDate ?? DateTime.now();
    _endDate = widget.event?.endDate ?? DateTime.now().add(const Duration(hours: 1));
  }

  Future<void> _pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImageFile = File(picked.path));
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() != true || _startDate == null || _endDate == null) return;

    widget.onSave(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      start: _startDate!,
      end: _endDate!,
      imageUrl: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : _selectedImageFile?.path,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event == null ? 'Add Event' : 'Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text('${_startDate?.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text('${_endDate?.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Pick Image from Gallery'),
                onPressed: _pickImageFromGallery,
              ),
              const SizedBox(height: 16),
              if (_selectedImageFile != null)
                Image.file(_selectedImageFile!, height: 200, fit: BoxFit.cover),
              if (_imageUrlController.text.isNotEmpty)
                Image.network(_imageUrlController.text, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

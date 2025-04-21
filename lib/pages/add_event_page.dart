import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event_model.dart';

class AddEventPage extends StatefulWidget {
  // final EventModel? event;
  // final Future<void> Function({
  //   required String title,
  //   required String description,
  //   required DateTime start,
  //   required DateTime end,
  //   String? imageUrl,W
  // }) onSave;

  // const AddEditEventPage({
  //   super.key,
  //   this.event,
  //   required this.onSave,
  // });

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  DateTime? _date;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImageFile;

  // @override
  // void initState() {
  //   super.initState();
  //   _titleController = TextEditingController(text: widget.event?.title ?? '');
  //   _descriptionController = TextEditingController(text: widget.event?.description ?? '');
  //   _imageUrlController = TextEditingController(text: widget.event?.imageUrl ?? '');
  //   _startDate = widget.event?.startDate ?? DateTime.now();
  //   _endDate = widget.event?.endDate ?? DateTime.now().add(const Duration(hours: 1));
  // }

  // Future<void> _pickImageFromGallery() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() => _selectedImageFile = File(picked.path));
  //   }
  // }

  void _save() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _idController.text.isNotEmpty) {
      await EventModel.addEvent(
        _idController.text,
        _titleController.text,
        _descriptionController.text,
        _date!,
        _timeController.text,
        _locationController.text,
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
      );

      Navigator.pop(context, true); 
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please put all info.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'id'),
                validator: (value) => value!.isEmpty ? 'Id' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Id' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text('${_date?.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              const SizedBox(height: 10),
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

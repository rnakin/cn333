import 'package:flutter/material.dart';
import 'package:tuquest/models/class.dart';
import 'package:tuquest/services/firebase_service.dart';

class AddClassScreen extends StatefulWidget {
  final String day;
  const AddClassScreen({super.key, required this.day});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  void _saveClass() async {
    if (_formKey.currentState?.validate() ?? false) {
      final classModel = ClassModel(
        id: '',
        code: _codeController.text,
        name: _nameController.text,
        room: _roomController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
      );

      await FirebaseService().addClassForDay(widget.day, classModel);
      Navigator.pop(context); // return to previous screen and refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Class Code'),
                validator: (val) => val!.isEmpty ? 'Enter class code' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Class Name'),
                validator: (val) => val!.isEmpty ? 'Enter class name' : null,
              ),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room'),
                validator: (val) => val!.isEmpty ? 'Enter room' : null,
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time (e.g. 09:00 AM)',
                ),
                validator: (val) => val!.isEmpty ? 'Enter start time' : null,
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'End Time (e.g. 10:00 AM)',
                ),
                validator: (val) => val!.isEmpty ? 'Enter end time' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveClass,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Save Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

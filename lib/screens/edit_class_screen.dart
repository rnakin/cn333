import 'package:flutter/material.dart';
import 'package:tuquest/models/class.dart';
import 'package:tuquest/services/firebase_service.dart';

class EditClassScreen extends StatefulWidget {
  final String day;
  final ClassModel classModel;

  const EditClassScreen({
    super.key,
    required this.day,
    required this.classModel,
  });

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController roomController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController(text: widget.classModel.code);
    nameController = TextEditingController(text: widget.classModel.name);
    roomController = TextEditingController(text: widget.classModel.room);
    startTimeController = TextEditingController(
      text: widget.classModel.startTime,
    );
    endTimeController = TextEditingController(text: widget.classModel.endTime);
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    roomController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedClass = ClassModel(
      id: widget.classModel.id,
      code: codeController.text,
      name: nameController.text,
      room: roomController.text,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
    );

    await _firebaseService.updateClass(
      widget.day,
      widget.classModel.id,
      updatedClass,
    );
    Navigator.pop(context); // go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Class"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: "Code"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: roomController,
              decoration: const InputDecoration(labelText: "Room"),
            ),
            TextField(
              controller: startTimeController,
              decoration: const InputDecoration(labelText: "Start Time"),
            ),
            TextField(
              controller: endTimeController,
              decoration: const InputDecoration(labelText: "End Time"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

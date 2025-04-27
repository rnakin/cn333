import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  const AddEventPage({super.key, required this.selectedDate});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _topicController = TextEditingController();
  final _detailController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.selectedDate;
    _endDate = widget.selectedDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate ? (_startDate ?? widget.selectedDate) : (_endDate ?? widget.selectedDate);
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _saveEvent() async {
    if (_topicController.text.isEmpty || _detailController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    final newEvent = {
      'topic': _topicController.text,
      'detail': _detailController.text,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'startDate': Timestamp.fromDate(_startDate!),
      'endDate': Timestamp.fromDate(_endDate!),
      'imageUrl': imageUrl ?? '',
      'isNetworkImage': true,
      'creatorUID': FirebaseAuth.instance.currentUser?.uid ?? '',
    };

    FirebaseFirestore.instance.collection('events').add(newEvent).then((docRef) {
      Navigator.pop(context);
    }).catchError((e) {
      print("Error adding event: $e");
    }).whenComplete(() {
      setState(() {
        _isUploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มกิจกรรม"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _topicController,
                decoration: InputDecoration(labelText: "หัวข้อกิจกรรม"),
              ),
              TextField(
                controller: _detailController,
                decoration: InputDecoration(labelText: "รายละเอียดกิจกรรม"),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("วันที่เริ่มต้น: ${_startDate != null ? DateFormat('d MMM yyyy').format(_startDate!) : 'เลือกวันที่'}"),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("วันที่สิ้นสุด: ${_endDate != null ? DateFormat('d MMM yyyy').format(_endDate!) : 'เลือกวันที่'}"),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveEvent,
                      child: Text("บันทึกกิจกรรม"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Set the selected date as the default start date
    _startDate = widget.selectedDate;
    _endDate = widget.selectedDate; // By default, end date is the same as start date
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มกิจกรรม"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            SizedBox(height: 16),
            // Start Date Picker
            Row(
              children: [
                Text("วันที่เริ่มต้น: ${_startDate != null ? DateFormat('d MMM yyyy').format(_startDate!) : 'เลือกวันที่'}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ],
            ),
            // End Date Picker
            Row(
              children: [
                Text("วันที่สิ้นสุด: ${_endDate != null ? DateFormat('d MMM yyyy').format(_endDate!) : 'เลือกวันที่'}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text("บันทึกกิจกรรม"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent() {
    if (_topicController.text.isEmpty || _detailController.text.isEmpty || _startDate == null || _endDate == null) {
      // Handle validation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
      return;
    }

    // Create a new event in Firestore
    final newEvent = {
      'topic': _topicController.text,
      'detail': _detailController.text,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'startDate': Timestamp.fromDate(_startDate!),
      'endDate': Timestamp.fromDate(_endDate!),
    };

    FirebaseFirestore.instance.collection('events').add(newEvent).then((docRef) {
      // Success, navigate back to the previous screen
      Navigator.pop(context);
    }).catchError((e) {
      // Handle error
      print("Error adding event: $e");
    });
  }
}

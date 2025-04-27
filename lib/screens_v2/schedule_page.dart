import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuquest/screens_v2/virtual_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<String> days = ['S', 'M', 'T', 'W', 'TH', 'F', 'SA'];
  String selectedDay = 'M';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Replace with the actual user's ID from Firebase Auth or other source
  final String userId = 'userIdHere';

  // 🔵 Reusable TextField Widget
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isTime = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: isTime ? TextInputType.datetime : TextInputType.text,
      ),
    );
  }

  // 🟢 Add/Edit Schedule Dialog
  void _showScheduleDialog({DocumentSnapshot? doc}) {
    final start = TextEditingController(text: doc?['start'] ?? '');
    final end = TextEditingController(text: doc?['end'] ?? '');
    final code = TextEditingController(text: doc?['code'] ?? '');
    final subject = TextEditingController(text: doc?['subject'] ?? '');
    final room = TextEditingController(text: doc?['room'] ?? '');

    final isEditing = doc != null;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.only(left: 20, right: 4, top: 20),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'แก้ไขตารางเรียน' : 'เพิ่มตารางเรียน',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFFF8000),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField('เวลาเริ่ม', start, isTime: true),
                  _buildTextField('เวลาเลิก', end, isTime: true),
                  _buildTextField('รหัสวิชา', code),
                  _buildTextField('ชื่อวิชา', subject),
                  _buildTextField('ห้องเรียน', room),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Discard',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (start.text.isEmpty ||
                      end.text.isEmpty ||
                      code.text.isEmpty ||
                      subject.text.isEmpty ||
                      room.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                  final newClass = {
                    'start': start.text,
                    'end': end.text,
                    'code': code.text,
                    'subject': subject.text,
                    'room': room.text,
                    'userId': userId, // Add this line
                  };

                  if (isEditing) {
                    // Update existing schedule
                    await firestore
                        .collection('schedule')
                        .doc(
                          userId,
                        ) // Ensure the user's own schedule is updated
                        .collection('items')
                        .doc(doc.id)
                        .set(newClass);
                  } else {
                    // Add new schedule
                    await firestore
                        .collection('schedule')
                        .doc(selectedDay)
                        .collection('items')
                        .add(newClass);
                  }

                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Save' : 'Add'),
              ),
            ],
          ),
    );
  }

  // 🟧 Main Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity! > 300) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => VirtualCardPage(
                      onBackToTop: () => Navigator.pop(context),
                    ),
              ),
            );
          }
        },
        onHorizontalDragEnd: (d) {
          if (d.primaryVelocity! > 300) Navigator.pop(context);
        },
        child: Container(
          color: const Color(0xFFFF9D00),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // 🧾 White Box
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🟠 Header + Add
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Classroom Schedule",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFFF8000),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showScheduleDialog(),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFFFF8000),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // 🔵 Day Buttons
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 18,
                            children:
                                days.map((d) {
                                  final selected = selectedDay == d;
                                  return GestureDetector(
                                    onTap:
                                        () => setState(() => selectedDay = d),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          selected
                                              ? Color(0xFFFF8000)
                                              : Colors.grey[300],
                                      radius: 18,
                                      child: Text(
                                        d,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 🟡 Class Schedule List
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream:
                                firestore
                                    .collection('schedule')
                                    .doc(selectedDay)
                                    .collection('items')
                                    .where(
                                      'userId',
                                      isEqualTo:
                                          FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid,
                                    ) // Add this filter
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text('No data available.'),
                                );
                              }

                              final scheduleDocs = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: scheduleDocs.length,
                                itemBuilder: (context, index) {
                                  final item = scheduleDocs[index];

                                  return GestureDetector(
                                    onTap: () => _showScheduleDialog(doc: item),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9D00),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Text(
                                              "${item['start']} - ${item['end']}",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${item['code']} · ${item['subject']}",
                                                  style: GoogleFonts.montserrat(
                                                    color: Color(0xFFA00000),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "🏫 ${item['room']}",
                                                  style: GoogleFonts.montserrat(
                                                    color: Color(0xFFeae0cb),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

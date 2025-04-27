import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets_v2/topbar.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final studentData = {
      'name': 'สมศักดิ์ สมชาย',
      'studentId': '6510615999',
      'faculty': 'วิศวกรรมศาสตร์',
      'email': 'somsakss@gmail.com',
      'gpax': '2.94',
      'credit': '102',
      'imageUrl': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนปุ่ม Back แยกต่างหาก
            Padding(
              padding: const EdgeInsets.only(left: 11, top: 22), 
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, 
                        color: Color(0xFFA00000), size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Back',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFA00000),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // ส่วนเนื้อหาหลัก
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26), // Padding ด้านข้างของเนื้อหา
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // รูปโปรไฟล์
                  Center(
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 78,
                        backgroundImage: NetworkImage(studentData['imageUrl']!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ข้อมูลนักศึกษา
                  _buildInfoSection(
                    label: 'ชื่อ - นามสกุล',
                    value: studentData['name']!,
                  ),
                  const SizedBox(height: 20),

                  _buildInfoSection(
                    label: 'รหัสนักศึกษา',
                    value: studentData['studentId']!,
                  ),
                  const SizedBox(height: 20),

                  _buildInfoSection(
                    label: 'คณะ',
                    value: studentData['faculty']!,
                  ),
                  const SizedBox(height: 20),

                  _buildInfoSection(
                    label: 'Email',
                    value: studentData['email']!,
                  ),
                  const SizedBox(height: 20),

                  // ส่วน GPAX และ Credit
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoSection(
                          label: 'GPAX',
                          value: studentData['gpax']!,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoSection(
                          label: 'Credit',
                          value: studentData['credit']!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.brown[900],
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFA00000),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
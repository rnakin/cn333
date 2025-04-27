import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tuquest/caching.dart';

class VirtualCardPage extends StatefulWidget {
  final VoidCallback onBackToTop;

  const VirtualCardPage({super.key, required this.onBackToTop});

  @override
  State<VirtualCardPage> createState() => _VirtualCardPageState();
}

class _VirtualCardPageState extends State<VirtualCardPage> {
  String studentId = '';

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    studentId = await Caching.readStringWithDefault(key: 'id');
    setState(() {}); // to refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      body: Column(
        children: [
          // 🧾 Card แสดงข้อมูล
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 58),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 48,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF000000), Color(0xFFFF0004)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      children: [
                        // โลโก้ธรรมศาสตร์
                        Image.asset(
                          'assets/thammasat_logo.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data:
                                    studentId, // ใช้รหัสนักศึกษาเป็นข้อมูลใน QR Code
                                version: QrVersions.auto,
                                size: 200,
                                backgroundColor: Colors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.black,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Colors.black,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Barcode ที่สามารถสแกนได้จริง
                  

                        const SizedBox(height: 20),

                        const SizedBox(height: 8),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

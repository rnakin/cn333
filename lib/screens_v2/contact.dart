import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets_v2/topbar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: ส่งข้อมูลไป backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), // เพิ่ม padding ด้านข้างทั้งหน้า
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button - เพิ่ม padding เฉพาะส่วนนี้
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 35), // ปรับ padding บน-ล่างให้มากขึ้น
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.chevron_left, color: Color(0xFFA00000), size: 32),
                      const SizedBox(width: 2), 
                      Text(
                        'Back',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFA00000),
                          fontWeight: FontWeight.w700,
                          fontSize: 20, 
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title - เพิ่ม padding เฉพาะส่วนนี้
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 30), // ปรับ padding ล่างให้มากขึ้น
                child: Text(
                  'Contact us',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32, // เพิ่มขนาด font
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // Form - เพิ่ม padding เฉพาะส่วนนี้
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // ปรับ padding ด้านข้างของฟอร์ม
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(controller: nameController, hint: 'Full name'),
                      const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างฟิลด์
                      _buildField(controller: emailController, hint: 'Email address'),
                      const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างฟิลด์
                      _buildField(
                        controller: messageController,
                        hint: 'Message...',
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 45), // เพิ่มระยะห่างก่อนปุ่ม Submit

              // Submit Button - เพิ่ม padding เฉพาะส่วนนี้
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6), // ปรับ padding ด้านข้างของปุ่ม
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA00000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16), // เพิ่ม padding ปุ่มให้สูงขึ้น
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // เพิ่มขนาด font
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // เพิ่มระยะห่างด้านล่างสุด
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 16), // เพิ่มขนาด font
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60, fontSize: 16), // เพิ่มขนาด font
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), // เพิ่ม padding ภายในฟิลด์
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
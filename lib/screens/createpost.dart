import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tuquest/widgets/bottom_nav.dart'; // ใช้ Bottom Navigation

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _image; // สำหรับเก็บรูปภาพที่เลือก

  final picker = ImagePicker();

  // ค่าเริ่มต้นของ Board และ Tags

  String selectedBoard = "Event";

  String selectedTag = "ของหาย";

  String selectedPostTime = "none";

  final TextEditingController _topicController = TextEditingController();

  final TextEditingController _detailController = TextEditingController();

  // ฟังก์ชันเลือกภาพจากเครื่อง

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        height: MediaQuery.of(context).size.height,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [Color(0xFF000000), Color(0xFFFF0004)],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Header "Create Post"
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFA00000),
                        Color(0xFFEA2520),
                        Color(0xFFFF8000),
                      ],

                      stops: [0.01, 0.52, 1.0],
                    ).createShader(bounds);
                  },

                  blendMode: BlendMode.srcIn,

                  child: const Text(
                    'Create Post',

                    style: TextStyle(
                      fontSize: 36,

                      fontWeight: FontWeight.bold,

                      fontFamily: 'Montserrat',

                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // อัปโหลดรูปภาพ
                GestureDetector(
                  onTap: _pickImage,

                  child: Container(
                    width: double.infinity,

                    height: 150,

                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8000),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child:
                        _image == null
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.white,
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    "Add Image",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                // Board Tags
                const Text(
                  "Board:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Wrap(
                  spacing: 8,

                  children:
                      ["Event", "Quest", "TUAlert"].map((board) {
                        return ChoiceChip(
                          label: Text(board),

                          selected: selectedBoard == board,

                          onSelected: (selected) {
                            setState(() {
                              selectedBoard = board;
                            });
                          },

                          selectedColor: Colors.orange,

                          backgroundColor: Colors.transparent,

                          labelStyle: TextStyle(
                            color:
                                selectedBoard == board
                                    ? Colors.black
                                    : Colors.orange,
                          ),

                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.orange),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 10),

                // Tags
                const Text(
                  "Tag:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Wrap(
                  spacing: 8,

                  children:
                      ["ของหาย", "ฝากหิ้ว"].map((tag) {
                        return ChoiceChip(
                          label: Text(tag),

                          selected: selectedTag == tag,

                          onSelected: (selected) {
                            setState(() {
                              selectedTag = tag;
                            });
                          },

                          selectedColor: Colors.orange,

                          backgroundColor: Colors.transparent,

                          labelStyle: TextStyle(
                            color:
                                selectedTag == tag
                                    ? Colors.black
                                    : Colors.orange,
                          ),

                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.orange),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 10),

                // Topic
                const Text(
                  "Topic:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextField(
                  controller: _topicController,

                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 10),

                // Detail
                const Text(
                  "Detail:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextField(
                  controller: _detailController,

                  maxLines: 3,

                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 10),

                // Post Time
                const Text(
                  "Post Time:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Wrap(
                  spacing: 8,

                  children:
                      ["none", "30 m", "45 m", "1 hr"].map((time) {
                        return ChoiceChip(
                          label: Text(time),

                          selected: selectedPostTime == time,

                          onSelected: (selected) {
                            setState(() {
                              selectedPostTime = time;
                            });
                          },

                          selectedColor: Colors.orange,

                          backgroundColor: Colors.transparent,

                          labelStyle: TextStyle(
                            color:
                                selectedPostTime == time
                                    ? Colors.black
                                    : Colors.orange,
                          ),

                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.orange),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),

                // ปุ่ม Save Draft, Create, และ Discard
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},

                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),

                      child: const Text(
                        "Save Draft",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),

                      child: const Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

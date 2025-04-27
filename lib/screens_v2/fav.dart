import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets_v2/topbar.dart';
import 'providers/fav_provider.dart';
import 'widgets_v2/post_card.dart';
import 'widgets_v2/navbar.dart';
import 'post_detail.dart';
import 'virtual_card.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> with AutomaticKeepAliveClientMixin {
  @override
bool get wantKeepAlive => true; // Keep the state of the page alive


  Future<void> _loadFavorites() async {
    final favProvider = Provider.of<FavProvider>(context, listen: false);
    await favProvider.loadFromFirebase();
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();  
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity! > 300) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VirtualCardPage(
                  onBackToTop: () => Navigator.pop(context),
                ),
              ),
            );
          }
        },
        child: Container(
          color: const Color(0xFFFF9D00),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // White Container
              Expanded(
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "โพสต์ที่บันทึกไว้",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8000),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xFFFF8000),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Content
                        Expanded(
                          child: Consumer<FavProvider>( // Listen to changes in FavProvider
                            builder: (context, favProvider, child) {
                              final favs = favProvider.favs;

                              // If no favorite posts
                              if (favs.isEmpty) {
                                return Center(
                                  child: Text(
                                    "ยังไม่มีโพสต์ที่บันทึกไว้",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              }

                              // List of favorite posts
                              return ListView.builder(
                                itemCount: favs.length,
                                itemBuilder: (context, index) {
                                  final post = favs[index];
                                  return Column(
                                    children: [
                                      PostCard(
                                        post: post,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PostDetailPage.fromPost(post: post),
                                          ),
                                        ),
                                      ),
                                      if (index != favs.length - 1)
                                        const SizedBox(height: 12),
                                    ],
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

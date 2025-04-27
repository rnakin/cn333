import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuquest/auth.dart';
import 'package:tuquest/screens_v2/login.dart';
import '../noti.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool showNotificationIcon;

  const CustomTopBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.title = "NotiTU",
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFFA00000),
    this.showNotificationIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      surfaceTintColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading:
          showBackButton
              ? IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
              : null,
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
      actions:
          showNotificationIcon
              ? [
                Icon(Icons.chat_bubble_outline, color: Colors.red[200]),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.notifications_none, color: textColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotiPage()),
                    );
                  },
                ),
                const SizedBox(width: 10),
                // Add the menu with Logout option
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: textColor),
                  onSelected: (value) {
                    if (value == 'logout') {
                      // Call logout function when 'logout' is selected
                      TQauth.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

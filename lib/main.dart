import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_option.dart';
import 'pages/homepage.dart';
import 'pages/login.dart';


ThemeData LightMode = ThemeData(
  textTheme: const TextTheme(
  bodyLarge: TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
  ), // Default text color for large text
  bodyMedium: TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
  ), // Default text color for medium text
  bodySmall: TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
  ), // Default text color for small text
 ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade50,
    primary: Colors.grey.shade100,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade600

  )
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Quest',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      theme: LightMode,
    );
  }
}

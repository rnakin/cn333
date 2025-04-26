import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tuquest/screens_v2/home/home.dart';
import 'screens_v2/login.dart';
import 'screens_v2/providers/fav_provider.dart';
import 'screens_v2/providers/navbar_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await initializeDateFormatting('th', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavProvider()),
        ChangeNotifierProvider(create: (_) => NavBarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'NotiTU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 166, 35, 39),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      home:user==null ? const SplashPage(): const HomePage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NotiTU",
              style: GoogleFonts.montserrat(
                fontSize: 75,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA00000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

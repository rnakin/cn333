import 'package:flutter/material.dart';
import 'package:tuquest/screens_v2/fav.dart';
import '../widgets_v2/topbar.dart';
import '../widgets_v2/announce_card.dart';
import '../widgets_v2/calendar.dart';
import '../widgets_v2/listevent.dart';
import '../schedule_page.dart';
import '../virtual_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: AnnounceCard(),
          ),
          const SizedBox(height: 16),
          CalendarSection(onDateSelected: _onDateSelected),
          const SizedBox(height: 16),
          ListEventSection(selectedDate: _selectedDate),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9D00),
      appBar: const CustomTopBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: _buildHomeContent(),
          ),
          const SchedulePage(),
          VirtualCardPage(
            onBackToTop: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          const FavPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF9D00),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

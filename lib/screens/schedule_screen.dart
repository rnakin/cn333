import 'package:flutter/material.dart';
import 'package:tuquest/widgets/weekly_schedule.dart';
import 'package:tuquest/services/firebase_service.dart';
import 'package:tuquest/screens/add_class_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> days = ['S', 'M', 'T', 'W', 'TH', 'F', 'SA'];
  final List<String> dayKeys = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  int selectedDayIndex = 0;
  final FirebaseService _firebaseService = FirebaseService();

  final GlobalKey<WeeklyScheduleState> _scheduleKey =
      GlobalKey<WeeklyScheduleState>();

  @override
  Widget build(BuildContext context) {
    String currentDay = dayKeys[selectedDayIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Schedule'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddClassScreen(day: currentDay),
                ),
              );
              _scheduleKey.currentState?.refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(days.length, (index) {
              return GestureDetector(
                onTap: () => setState(() => selectedDayIndex = index),
                child: CircleAvatar(
                  backgroundColor:
                      selectedDayIndex == index
                          ? Colors.amber
                          : Colors.grey[300],
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color:
                          selectedDayIndex == index
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          Expanded(child: WeeklySchedule(key: _scheduleKey, day: currentDay)),
        ],
      ),
    );
  }
}

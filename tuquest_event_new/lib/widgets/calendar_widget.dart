import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final Map<DateTime, List<String>> events;
  final Function(DateTime) onMonthChanged;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.events,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableGestures: AvailableGestures.none,
      onPageChanged: onMonthChanged,
      eventLoader: (day) => events[day] ?? [],
    );
  }
}

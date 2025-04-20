import 'package:flutter/material.dart';
import 'package:tuquest/models/class.dart';
import 'package:tuquest/services/firebase_service.dart';
import 'package:tuquest/screens/edit_class_screen.dart';

class WeeklySchedule extends StatefulWidget {
  final String day;
  const WeeklySchedule({super.key, required this.day});

  @override
  State<WeeklySchedule> createState() => WeeklyScheduleState();
}

class WeeklyScheduleState extends State<WeeklySchedule> {
  late Future<List<ClassModel>> _classFuture;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    _classFuture = FirebaseService.getClassesForDay(widget.day);
  }

  void refresh() {
    setState(() {
      _loadClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClassModel>>(
      future: _classFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final classes = snapshot.data ?? [];

        if (classes.isEmpty) {
          return const Center(child: Text("No classes for this day."));
        }

        return ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final c = classes[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('${c.code} - ${c.name}'),
                subtitle: Text(
                  '${c.startTime} - ${c.endTime}\nRoom: ${c.room}',
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditClassScreen(
                                day: widget.day,
                                classModel: c,
                              ),
                        ),
                      );
                      refresh();
                    } else if (value == 'delete') {
                      await FirebaseService().deleteClass(widget.day, c.id);
                      refresh();
                    }
                  },
                  itemBuilder:
                      (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

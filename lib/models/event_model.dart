import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final DateTime date;
  final String? imageUrl;
  final String? createdBy;
  final String location;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.location,
    this.imageUrl,
    this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
    };
  }

  static Future<void> addEvent(String id, String title, String description, DateTime date, String location, String time,{String? imageUrl}) async {
    final db = FirebaseFirestore.instance;
    final eventRef = db.collection('events').doc(); // gen id

    EventModel newEvent = EventModel(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      time: time,
      imageUrl: imageUrl,
    );

    await eventRef.set(newEvent.toMap());
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
      location: data['title'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? '',
    );
  }
}

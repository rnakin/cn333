import 'package:cloud_firestore/cloud_firestore.dart';

class Quest {
  final String id;
  final String title;
  final Timestamp timestamp;
  String? description;
  String? imagePath;
  
  Quest({
    required this.id,
    required this.title,
    required this.timestamp,
    this.description,
    this.imagePath,
  });


String getID(){
  return id;
}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp,
      'description': description,
      'imagePath': imagePath,
    };
  }
Quest copyWith({
    String? title,
    String? description,
    String? imagePath,
    Timestamp? timestamp,
  }) {
    return Quest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
    );}
    
factory Quest.fromMap(Map<String, dynamic> map, String documentId) {
  return Quest(
    id: documentId,
    title: map['title'] ?? 'Untitled Quest',
    timestamp: map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
    description: map['description'] ?? 'No description available',
    imagePath: map['imagePath'] ?? '',
  );
}

  static Future<List<Quest>> getQuests() async {
  final db = FirebaseFirestore.instance;
  QuerySnapshot snapshot = await db.collection('quests').orderBy('timestamp', descending: true).get();

  return snapshot.docs.map((doc) => Quest.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
}

static Future<void> updateQuest(String questId, String newTitle) async {
  final db = FirebaseFirestore.instance;
  await db.collection('quests').doc(questId).update({'title': newTitle});
}

static Future<void> addQuest(String title, String description, {String? imagePath}) async {
  final db = FirebaseFirestore.instance;
  final questRef = db.collection('quests').doc(); // gen id

  Quest newQuest = Quest(
    id: questRef.id,
    title: title,
    description: description,
    imagePath: imagePath,
    timestamp: Timestamp.now(),
  );

  await questRef.set(newQuest.toMap());
}
}

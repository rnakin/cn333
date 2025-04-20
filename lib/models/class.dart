class ClassModel {
  final String id;
  final String code;
  final String name;
  final String room;
  final String startTime;
  final String endTime;

  ClassModel({
    required this.id,
    required this.code,
    required this.name,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  factory ClassModel.fromMap(Map<String, dynamic> data, String docId) {
    return ClassModel(
      id: docId,
      code: data['code'],
      name: data['name'],
      room: data['room'],
      startTime: data['startTime'],
      endTime: data['endTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'room': room,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

import 'package:tuquest/models/user_model.dart';

class Chat {
  final User user;
  final String text;
  final String time;

  Chat({
    required this.user,
    required this.text,
    required this.time,
  });

  // Convert JSON to User Object
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      user: json['user'],
      text: json['text'],
      time: json['time'],
    );
  }

  // Convert User Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'text': text,
      'time': time,
    };
  }
}
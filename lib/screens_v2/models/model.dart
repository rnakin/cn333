import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String topic;
  final String detail;
  final String imageUrl;
  final bool isNetworkImage;
  final DateTime createdAt;
  final String creatorUID;  // Added creatorUID

  Post({
    required this.id,
    required this.topic,
    required this.detail,
    required this.imageUrl,
    this.isNetworkImage = true, // Default true
    required this.createdAt,
    required this.creatorUID,   // Added creatorUID
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      detail: json['detail'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isNetworkImage: json['isNetworkImage'] ?? true,
      createdAt: _parseDateTime(json['createdAt']),
      creatorUID: json['creatorUID'] ?? '',  // Extract creatorUID
    );
  }

  /// Helper function for parsing date
  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now(); // fallback in case of no value
    if (date is String) return DateTime.parse(date);
    if (date is Timestamp) return date.toDate();
    throw Exception('Invalid date format: $date');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'detail': detail,
      'imageUrl': imageUrl,
      'isNetworkImage': isNetworkImage,
      'createdAt': createdAt.toIso8601String(),
      'creatorUID': creatorUID,  // Include creatorUID in toJson
    };
  }
}

class Event extends Post {
  final DateTime startDate;
  final DateTime endDate;

  Event({
    required String id,
    required String topic,
    required String detail,
    required String imageUrl,
    bool isNetworkImage = true,
    required DateTime createdAt,
    required String creatorUID,  // Added creatorUID to Event
    required this.startDate,
    required this.endDate,
  }) : super(
          id: id,
          topic: topic,
          detail: detail,
          imageUrl: imageUrl,
          isNetworkImage: isNetworkImage,
          createdAt: createdAt,
          creatorUID: creatorUID,  // Pass creatorUID to superclass
        );

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      detail: json['detail'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isNetworkImage: json['isNetworkImage'] ?? true,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt'] as Timestamp).toDate(),
      creatorUID: json['creatorUID'] ?? '',  // Extract creatorUID
      startDate: json['startDate'] is String
          ? DateTime.parse(json['startDate'])
          : (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] is String
          ? DateTime.parse(json['endDate'])
          : (json['endDate'] as Timestamp).toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
    return data;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIn {
  final String id;
  final String userId;
  final DateTime date;
  final int mood;
  final String? note;

  CheckIn({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    this.note,
  });

  factory CheckIn.fromMap(Map<String, dynamic> map, String id) {
    return CheckIn(
      id: id,
      userId: map['userId'],
      date: (map['date'] as Timestamp).toDate(),
      mood: map['mood'] as int,
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'mood': mood,
      'note': note,
    };
  }
}
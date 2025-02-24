import 'package:cloud_firestore/cloud_firestore.dart';

class AgendaModel {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> members;
  // final bool isCompleted;

  AgendaModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.members,
    // required this.isCompleted,
  });

  factory AgendaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AgendaModel(
      id: doc.id,
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: data['description'] ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (data['endTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      members: List<String>.from(data['members'] ?? []),
      // isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'members': members,
      // 'isCompleted': isCompleted,
    };
  }
}

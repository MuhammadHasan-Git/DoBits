import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCategory {
  final String? id;
  final String name;
  final int color;
  final Timestamp? createdOn;

  TaskCategory(
      {this.id, this.createdOn, required this.color, required this.name});
}

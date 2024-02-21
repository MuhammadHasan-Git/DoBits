import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';

class Task {
  final String id;
  final FieldValue createdOn;
  final String title;
  final String date;
  final String? description;
  final String time;
  final TaskCategory category;
  final String priority;
  final bool isRemind;
  final List<SubTasksModel>? subTasks;
  final bool isCompleted;

  Task({
    required this.createdOn,
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.time,
    required this.category,
    required this.priority,
    required this.isRemind,
    required this.isCompleted,
    this.subTasks,
  });
}

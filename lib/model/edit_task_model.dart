import 'package:todo_app/model/category.dart';

class EditTaskModel {
  final String id;
  final String title;
  final String? description;
  final String date;
  final String time;
  final TaskCategory category;
  final String priorities;
  final bool isRemind;
  EditTaskModel(
      {required this.id,
      required this.title,
      this.description,
      required this.date,
      required this.time,
      required this.category,
      required this.priorities,
      required this.isRemind});
}

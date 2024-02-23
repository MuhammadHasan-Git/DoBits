import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/view/widget/task_card.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {super.key,
      required this.snapshot,
      this.showCompletedTask = false,
      required this.mobileId});
  final String mobileId;
  final bool showCompletedTask;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: snapshot.data != null ? snapshot.data!.docs.length : 0,
        itemBuilder: (context, index) {
          // final category = TaskCategory(
          //     color: int.parse(ds['categoryColor']), name: ds['categoryName']);
          if (snapshot.hasData) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            final Task task = Task(
                createdOn: ds['createdOn'],
                id: ds.id,
                title: ds['title'],
                date: ds['date'],
                description: ds['description'],
                time: ds['time'],
                category: TaskCategory(
                    color: int.parse(ds['categoryColor']),
                    name: ds['categoryName']),
                priority: ds['priority'],
                isRemind: ds['isRemind'],
                subTasks: List<SubTasksModel>.from(
                  (ds['subTasks'] as List).map(
                    (e) => SubTasksModel.fromJson(e),
                  ),
                ),
                isCompleted: ds['isCompleted']);
            return 
              TaskCard(
                    task: task,
                    index: index,
                    mobileId: mobileId,
                  )
               ;
          } else {
            return const SizedBox();
          }
        });
  }
}

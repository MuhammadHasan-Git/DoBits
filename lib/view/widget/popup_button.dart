import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/edit_task_model.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/add_task.dart';

class PopupButton extends StatelessWidget {
  final DocumentSnapshot ds;
  const PopupButton({
    super.key,
    required this.ds,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return PopupMenuButton(
      padding: EdgeInsets.zero,
      splashRadius: 30,
      constraints: const BoxConstraints(),
      color: black,
      surfaceTintColor: black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            Get.to(
              () => AddTask(
                editModel: EditTaskModel(
                    id: ds.id,
                    title: ds['title'],
                    description: ds['description'],
                    date: ds['date'],
                    time: ds['time'],
                    category: TaskCategory(
                        color: int.parse(ds['categoryColor']),
                        name: ds['categoryName']),
                    priorities: ds['priority'],
                    // subtasks: List<String>.from(ds['subTasks']),
                    isRemind: ds['isRemind']),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(
                width: 4.0.wp,
              ),
              const Text(
                "Edit Task",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.done,
                color: Colors.green,
              ),
              SizedBox(
                width: 4.0.wp,
              ),
              const Text(
                "Mark As Completed",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => homeController.alertDialog(ds),
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
              SizedBox(
                width: 4.0.wp,
              ),
              const Text(
                "Delete Task",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
      offset: const Offset(0, 30),
      child: const Icon(
        Icons.more_vert,
        color: white,
      ),
    );
  }
}

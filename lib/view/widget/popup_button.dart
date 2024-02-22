import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/edit_task_model.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/add_task.dart';

class PopupButton extends StatelessWidget {
  final Task task;
  const PopupButton({
    super.key,
    required this.task,
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
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    date: task.date,
                    time: task.time,
                    category: TaskCategory(
                        color: task.category.color,
                        name: task.category.name,
                        createdOn: task.createdOn),
                    priorities: task.priority,
                    subtasks: List<SubTasksModel>.from((task.subTasks as List)
                        .map((e) => SubTasksModel.fromJson(e))),
                    isRemind: task.isRemind),
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
              Text(
                "Edit Task",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => homeController.completeTask(task.id),
          child: Row(
            children: [
              const Icon(
                Icons.done,
                color: Colors.green,
              ),
              SizedBox(
                width: 4.0.wp,
              ),
              Text(
                "Mark As Completed",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => homeController.alertDialog(task.id),
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
              Text(
                "Delete Task",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.sp,
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

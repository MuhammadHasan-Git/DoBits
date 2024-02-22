import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/sub_task.dart';
import 'package:todo_app/model/edit_task_model.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/view/widget/text_field.dart';

class SubTask extends StatelessWidget {
  final EditTaskModel? editTaskModel;
  const SubTask({super.key, required this.editTaskModel});

  @override
  Widget build(BuildContext context) {
    final subTaskController = Get.put(SubTaskController());
    return Column(
      children: [
        FadeIn(
          child: CustomTextField(
              controller: subTaskController.textControlelr,
              hintText: 'Subtasks',
              onFieldSubmitted: (value) {
                SubTasksModel subTasksModel =
                    SubTasksModel(subtask: value, done: false);
                subTaskController.addSubtask(
                    subTasksModel, subTaskController.subTaskList.length);
              }),
        ),
        Obx(
          () => AnimatedList(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            key: subTaskController.listKey,
            initialItemCount: subTaskController.subTaskList.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return subTaskController.buildItem(
                  SubTasksModel(
                      subtask: subTaskController.subTaskList[index].subtask,
                      done: subTaskController.subTaskList[index].done),
                  animation);
            },
          ),
        ),
      ],
    );
  }
}

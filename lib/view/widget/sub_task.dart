import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/sub_task.dart';
import 'package:todo_app/view/widget/text_field.dart';

class SubTask extends StatelessWidget {
  const SubTask({super.key});

  @override
  Widget build(BuildContext context) {
    final subTaskController = Get.put(SubTaskController());
    return Column(
      children: [
        CustomTextField(
          controller: subTaskController.textControlelr,
          hintText: 'Subtasks',
          onFieldSubmitted: (value) => subTaskController.addSubtask(
              value, subTaskController.subTasks.length),
        ),
        SizedBox(
          child: AnimatedList(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            key: subTaskController.listKey,
            initialItemCount: subTaskController.subTasks.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return subTaskController.buildItem(
                  subTaskController.subTasks[index], animation);
            },
          ),
        ),
      ],
    );
  }
}

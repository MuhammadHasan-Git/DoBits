import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class TaskPriority extends StatelessWidget {
  const TaskPriority({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                toggleable: true,
                fillColor: const MaterialStatePropertyAll(Colors.green),
                activeColor: Colors.green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                value: "Low Priority",
                groupValue: taskController.selectedPriority.value,
                onChanged: (value) {
                  taskController.selectedPriority.value = value!;
                },
              ),
              SizedBox(
                width: 1.0.wp,
              ),
              const Text(
                'Low',
                style: TextStyle(
                  color: white,
                ),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: "Medium Priority",
                groupValue: taskController.selectedPriority.value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                fillColor: const MaterialStatePropertyAll(Colors.orange),
                activeColor: Colors.orange,
                onChanged: (value) {
                  taskController.selectedPriority.value = value!;
                },
              ),
              SizedBox(
                width: 1.0.wp,
              ),
              const Text(
                'Medium',
                style: TextStyle(
                  color: white,
                ),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: "High Priority",
                groupValue: taskController.selectedPriority.value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                fillColor: const MaterialStatePropertyAll(Colors.red),
                activeColor: Colors.red,
                onChanged: (value) {
                  taskController.selectedPriority.value = value!;
                },
              ),
              SizedBox(
                width: 1.0.wp,
              ),
              const Text(
                'High',
                style: TextStyle(
                  color: white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

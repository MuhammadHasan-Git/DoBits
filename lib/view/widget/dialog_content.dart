import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/widget/color_picker.dart';
import 'package:todo_app/view/widget/text_field.dart';

class DialogContent extends StatelessWidget {
  const DialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          width: double.infinity,
          controller: taskController.categoryTitle,
        ),
        SizedBox(
          height: 5.0.wp,
        ),
        const Text(
          "Select Color",
          style: TextStyle(color: white, fontSize: 16),
        ),
        ColorPicker(),
      ],
    );
  }
}

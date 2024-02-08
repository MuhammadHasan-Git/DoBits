import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/widget/category.dart';
import 'package:todo_app/view/widget/text_field.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        title: const Text(
          "New Task",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(
                  color: white,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                width: double.infinity,
                controller: taskController.titleController,
                hintText: 'e.g. Read a book',
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Date",
                style: TextStyle(
                  color: white,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                width: double.infinity,
                controller: taskController.dateInput,
                readOnly: true,
                onTap: () => taskController.displayDatePicker(context),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Start Time",
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        width: Get.width / 2 * 0.5,
                        textAlign: TextAlign.center,
                        controller: taskController.startTimeInput,
                        readOnly: true,
                        onTap: () => taskController.displayTimePicker(
                            context, taskController.startTimeInput, 1),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "End Time",
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        width: Get.width / 2 * 0.5,
                        textAlign: TextAlign.center,
                        controller: taskController.endTimeInput,
                        readOnly: true,
                        onTap: () => taskController.displayTimePicker(
                            context, taskController.endTimeInput, 2),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Select Category",
                style: TextStyle(
                  color: white,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CategoryList(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/widget/button.dart';
import 'package:todo_app/view/widget/category.dart';
import 'package:todo_app/view/widget/remind_widget.dart';
import 'package:todo_app/view/widget/task_priority.dart';
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
          child: Form(
            key: TaskController.formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter task name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            controller: taskController.dateInput,
                            textAlign: TextAlign.center,
                            readOnly: true,
                            onTap: () =>
                                taskController.displayDatePicker(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 12.0.wp,
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Time",
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            textAlign: TextAlign.center,
                            controller: taskController.timeInput,
                            readOnly: true,
                            onTap: () => taskController.displayTimePicker(
                                context, taskController.timeInput),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Description (optional)",
                  style: TextStyle(
                    color: white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  width: double.infinity,
                  controller: taskController.descriptionController,
                  hintText: 'Description',
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
                const CategoryList(),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Set Priorities",
                  style: TextStyle(
                    color: white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const TaskPriority(),
                const SizedBox(
                  height: 30,
                ),
                const Reminder(),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    text: "Create Task",
                    onPressed: () async {
                      if (TaskController.formKey.currentState!.validate()) {
                        await taskController.createTask(
                          context: context,
                          title: taskController.titleController.text,
                          date: taskController.dateInput.text,
                          time: taskController.timeInput.text,
                          category: taskController
                              .categories[taskController.chipIndex.value],
                          priority: taskController.selectedPriority.value,
                          isRemind: taskController.isRemind.value,
                          subTasks: [],
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

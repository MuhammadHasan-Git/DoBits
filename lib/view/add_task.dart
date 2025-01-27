import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/sub_task.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/widget/button.dart';
import 'package:todo_app/view/widget/category.dart';
import 'package:todo_app/view/widget/remind_widget.dart';
import 'package:todo_app/view/widget/sub_task.dart';
import 'package:todo_app/view/widget/task_priority.dart';
import 'package:todo_app/view/widget/text_field.dart';

class AddTaskPage extends StatelessWidget {
  final Task? editModel;
  const AddTaskPage({super.key, this.editModel});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController(editTaskModel: editModel));

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            editModel != null ? "Edit Task" : "Create Task",
            style: const TextStyle(color: white),
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
                  FadeIn(
                    child: CustomTextField(
                      width: double.infinity,
                      autofocus: editModel == null,
                      controller: taskController.titleController,
                      hintText: 'e.g. Read a book',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter task name";
                        }
                        return null;
                      },
                    ),
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
                            FadeIn(
                              child: CustomTextField(
                                controller: taskController.dateInput,
                                textAlign: TextAlign.center,
                                readOnly: true,
                                onTap: () =>
                                    taskController.displayDatePicker(context),
                              ),
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
                            FadeIn(
                              child: CustomTextField(
                                textAlign: TextAlign.center,
                                controller: taskController.timeInput,
                                readOnly: true,
                                onTap: () => taskController.displayTimePicker(
                                    context, taskController.timeInput),
                              ),
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
                  FadeIn(
                    child: CustomTextField(
                      width: double.infinity,
                      controller: taskController.descriptionController,
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Sub Task",
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubTask(
                    editTaskModel: editModel,
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
                  CategoryList(
                    editTaskModel: editModel,
                  ),
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
                      text: editModel == null ? "Create Task" : "Update",
                      onPressed: () async {
                        final subTaskCtrl = Get.find<SubTaskController>();
                        final Task task = Task(
                          createdOn: Timestamp.now(),
                          id: '',
                          title: taskController.titleController.text.trim(),
                          date: taskController.selectedDate!.toIso8601String(),
                          description:
                              taskController.descriptionController.text.trim(),
                          time: taskController.selectedTime!.toIso8601String(),
                          category: taskController
                              .categories[taskController.chipIndex.value],
                          priority: taskController.selectedPriority.value,
                          isRemind: taskController.isRemind.value,
                          isCompleted: false,
                          subTasks: subTaskCtrl.subTaskList,
                        );
                        if (TaskController.formKey.currentState!.validate()) {
                          final subTaskController =
                              Get.find<SubTaskController>();
                          if (editModel == null) {
                            await taskController.createTask(taskModel: task);
                          } else {
                            final Task updateTaskModel = Task(
                              id: editModel!.id,
                              title: taskController.titleController.text,
                              description: taskController
                                          .descriptionController.text ==
                                      ''
                                  ? null
                                  : taskController.descriptionController.text,
                              date: taskController.selectedDate!
                                  .toIso8601String(),
                              time: taskController.selectedTime!
                                  .toIso8601String(),
                              category: taskController
                                  .categories[taskController.chipIndex.value],
                              priority: taskController.selectedPriority.value,
                              isRemind: taskController.isRemind.value,
                              subTasks: subTaskController.subTaskList.isEmpty
                                  ? []
                                  : subTaskController.subTaskList,
                              createdOn: Timestamp.now(),
                              isCompleted: false,
                            );
                            taskController.updateTask(updateTaskModel);
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());

    return Obx(
      () => Wrap(
        spacing: 2.0.wp,
        children: List.generate(taskController.categories.length + 1, (index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                taskController.dialogBuilder(context);
              },
              splashFactory: NoSplash.splashFactory,
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 120,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: white,
                    ),
                    Text(
                      "Add Category",
                      style: TextStyle(
                        fontSize: 12,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            final adjustedIndex = index - 1;

            return GestureDetector(
              onTap: () => taskController.chipIndex.value = adjustedIndex,
              onLongPress: () => taskController.deleteCategory(adjustedIndex),
              child: Chip(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                label: Text(
                  taskController.categories[adjustedIndex].name,
                  style: TextStyle(
                    fontSize: 12,
                    color: taskController.categories[adjustedIndex].color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                side: BorderSide(
                    color: taskController.chipIndex.value == adjustedIndex
                        ? taskController.categories[adjustedIndex].color
                        : Colors.transparent,
                    width: taskController.chipIndex.value == adjustedIndex
                        ? 2
                        : 0),
                color: MaterialStatePropertyAll(
                  taskController.categories[adjustedIndex].color
                      .withOpacity(0.15),
                ),
                surfaceTintColor: taskController.categories[adjustedIndex].color
                    .withOpacity(0.15),
              ),
            );
          }
        }),
      ),
    );
  }
}
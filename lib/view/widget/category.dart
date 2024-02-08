import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/constant.dart';
import 'package:todo_app/utils/extensions.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());

    return Wrap(
      spacing: 2.0.wp,
      children: List.generate(defaultCategories.length, (index) {
        final categoryList = TaskCategory(
            name: defaultCategories[index],
            color: defaultCategoriesColor[index]);
        if (index == defaultCategories.length - 1) {
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 120,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
          return GestureDetector(
            onTap: () => taskController.chipIndex.value = index,
            child: Obx(
              () => Chip(
                avatar: taskController.chipIndex.value == index
                    ? const Icon(Icons.done)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                label: Text(
                  categoryList.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: categoryList.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                side: BorderSide(
                    color: taskController.chipIndex.value == index
                        ? categoryList.color
                        : Colors.transparent,
                    width: taskController.chipIndex.value == index ? 2 : 0),
                color: MaterialStatePropertyAll(
                  categoryList.color.withOpacity(0.15),
                ),
                surfaceTintColor: categoryList.color.withOpacity(0.15),
              ),
            ),
          );
        }
      }),
    );
  }
}

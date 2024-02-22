import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.9);
  RxInt index = 0.obs;
  // late final String? mobileId;O

  // @override
  // Future<void> onInit() async {

  //   // mobileId = await UserController.getId();
  //   super.onInit();
  // }

  Future<dynamic> alertDialog(DocumentSnapshot ds) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: black,
        surfaceTintColor: black,
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Delete this task",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure! you want to delete this task",
          style: TextStyle(color: white),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                final taskController = Get.put(TaskController());
                taskController.deleteTask(ds.id);
              }),
        ],
      ),
    );
  }

  Color? getPriorityColor(value) {
    switch (value) {
      case "Low Priority":
        return Colors.green;
      case "Medium Priority":
        return Colors.orange;
      case "High Priority":
        return Colors.red;

      default:
        return null;
    }
  }
}

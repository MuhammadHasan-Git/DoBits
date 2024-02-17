import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/user_controller.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.9);
  RxInt index = 0.obs;
  late final String? mobileId;

  @override
  Future<void> onInit() async {
    mobileId = await UserController.getId();
    super.onInit();
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

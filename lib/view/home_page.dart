import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/add_task.dart';
import 'package:todo_app/view/widget/task_report.dart';
import 'package:todo_app/view/widget/task_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationServices notificationServices = NotificationServices();

   
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              TaskReport(),
              TaskBarView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        tooltip: 'Add Task',
        onPressed: () => Get.to(() => const AddTask()),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

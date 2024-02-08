import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/add_task.dart';
import 'package:todo_app/view/widget/priority_task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hey, welcome!",
                    style: TextStyle(
                      color: white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: blue,
                          backgroundColor: Colors.grey,
                          value: 0.3,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "Todays Progress",
                        style: TextStyle(
                          fontSize: 14,
                          color: blue,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "0 Tasks Left",
                        style: TextStyle(
                          fontSize: 14,
                          color: white.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0.wp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Priority Task",
                        style: TextStyle(
                          fontSize: 22,
                          color: white,
                        ),
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(blue),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        ),
                        onPressed: () {},
                        child: const Text("View all"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const PriorityTask(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today Task",
                        style: TextStyle(
                          fontSize: 22,
                          color: white,
                        ),
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(blue),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        ),
                        onPressed: () {},
                        child: const Text("View all"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        tooltip: 'Add Task',
        onPressed: () =>
            Get.to(() => const AddTask(), transition: Transition.downToUp),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

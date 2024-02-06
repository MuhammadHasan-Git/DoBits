import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/widget/priority_task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
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
                    SizedBox(
                      width: 2.0.wp,
                    ),
                    const Text(
                      "Todays Progress",
                      style: TextStyle(
                        fontSize: 14,
                        color: blue,
                      ),
                    ),
                    SizedBox(
                      width: 2.0.wp,
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
                    Text(
                      "Priority Task",
                      style: TextStyle(
                        fontSize: 16.0.sp,
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
        ],
      ),
    );
  }
}

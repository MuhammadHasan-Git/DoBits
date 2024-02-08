import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/controller/controller.dart';

class PriorityTask extends StatelessWidget {
  const PriorityTask({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return Column(
      children: [
        
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: homeController.pageController,
            itemCount: 4,
            pageSnapping: true,
            itemBuilder: (BuildContext context, pagePosition) {
              return Container(
                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// return SizedBox(
//       width: double.infinity,
//       height: 240,
//       child: PageView.builder(
//           controller: homeController.pageController,
//           itemCount: 2,
//           pageSnapping: true,
//           itemBuilder: (BuildContext context, pagePosition) {
//             return Container(
//               width: Get.width * 0.85,
//               height: 170,
//               decoration: BoxDecoration(
//                 color: white.withOpacity(0.5),
//               ),
//             );
//           }),
//     );

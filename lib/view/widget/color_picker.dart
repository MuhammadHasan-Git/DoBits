import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';

import '../../controller/task_controller.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    List<int> colors = const [
      0xff778CDD,
      0xffBC79BC,
      0xffE46D8D,
      0xffE56B68,
      0xff4AA079,
      0xff479E98,
      0xff88959E,
      0xffDFEDF8,
      0xffF2E7F8,
      0xffFFE4E9,
      0xffF9E8DE,
      0xffD5F1E5,
      0xffD4F1EF,
      0xffE7ECF0,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          colors.length,
          (index) => GestureDetector(
            onTap: () {
              taskController.buttonIndex.value = index;
              taskController.selectedColor.value = colors[index];
              log(colors[index].toString());
            },
            child: Obx(
              () => Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Color(colors[index]),
                  shape: BoxShape.circle,
                ),
                child: taskController.buttonIndex.value == index
                    ? const Icon(
                        Icons.circle,
                        size: 8,
                        color: white,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

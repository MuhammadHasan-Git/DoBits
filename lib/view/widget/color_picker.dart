import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';

import '../../controller/task_controller.dart';

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<Color> colors = const [
    Color(0xff778CDD),
    Color(0xffBC79BC),
    Color(0xffE46D8D),
    Color(0xffE56B68),
    Color(0xff4AA079),
    Color(0xff479E98),
    Color(0xff88959E),
    Color(0xffDFEDF8),
    Color(0xffF2E7F8),
    Color(0xffFFE4E9),
    Color(0xffF9E8DE),
    Color(0xffD5F1E5),
    Color(0xffD4F1EF),
    Color(0xffE7ECF0),
  ];

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
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
                  color: colors[index],
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

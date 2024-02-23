import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class Reminder extends StatelessWidget {
  const Reminder({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return darkBlue.withOpacity(0.2);
        }

        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return darkBlue.withOpacity(0.5);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return white.withOpacity(0.1);
        }
        return null;
      },
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: white.withOpacity(0.5),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alarm,
                  color: white,
                ),
              ),
              SizedBox(
                width: 3.0.wp,
              ),
              const Text(
                "Remind me",
                style: TextStyle(
                  color: white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Obx(
            () => Switch.adaptive(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: taskController.isRemind.value,
              thumbColor: const MaterialStatePropertyAll<Color>(darkBlue),
              trackColor: trackColor,
              overlayColor: overlayColor,
              inactiveTrackColor: white.withOpacity(0.1),
              trackOutlineWidth: const MaterialStatePropertyAll(0),
              trackOutlineColor:
                  const MaterialStatePropertyAll(Colors.transparent),
              onChanged: (bool value) {
                taskController.isRemind.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}

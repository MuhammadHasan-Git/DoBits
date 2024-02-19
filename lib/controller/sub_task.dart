import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class SubTaskController extends GetxController {
  final listKey = GlobalKey<AnimatedListState>();
  final textControlelr = TextEditingController();
  final RxList<String> subTasks = <String>[].obs;

  void addSubtask(String subtask, int index) {
    FocusManager.instance.primaryFocus?.requestFocus();
    if (textControlelr.text.isNotEmpty || textControlelr.text != '') {
      log(textControlelr.text.isEmpty.toString());

      subTasks.insert(index, subtask);
      listKey.currentState?.insertItem(index);
      textControlelr.clear();
    }
  }

  void deleteSubtask(int index) {
    final removedItem = subTasks[index];
    subTasks.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => buildItem(removedItem, animation),
    );
  }

  Widget buildItem(String item, Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Card(
          elevation: 10,
          color: white.withOpacity(0.1),
          surfaceTintColor: white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: white, fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 3.0.wp,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () => deleteSubtask(subTasks.indexOf(item)),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

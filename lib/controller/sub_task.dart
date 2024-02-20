import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class SubTaskController extends GetxController {
  final listKey = GlobalKey<AnimatedListState>();
  final textControlelr = TextEditingController();
  final RxList<SubTasksModel> subTaskList = <SubTasksModel>[].obs;
  getSubtask(SubTasksModel subTasksModel, index) {
    subTaskList.insert(index, subTasksModel);
    listKey.currentState?.insertItem(index);
  }

  void addSubtask(SubTasksModel subtask, int index) {
    FocusManager.instance.primaryFocus?.requestFocus();
    if (subTaskList.isNotEmpty &&
        subTaskList.firstWhereOrNull((element) =>
                element.subtask.trim() == subtask.subtask.trim()) !=
            null) {
      Fluttertoast.showToast(
          msg: "Todo item already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (subtask.subtask.trim().isNotEmpty) {
      subTaskList.insert(index, subtask);
      listKey.currentState?.insertItem(index);
      textControlelr.clear();
    }
  }

  void deleteSubtask(int index) {
    final removedItem = subTaskList[index];
    subTaskList.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => buildItem(removedItem, animation),
    );
  }

  Widget buildItem(SubTasksModel? item, Animation<double> animation) {
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
                    item!.subtask,
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
                  onPressed: () {
                    final SubTasksModel subTasksModel =
                        SubTasksModel(subtask: item.subtask, done: item.done);
                    deleteSubtask(subTaskList.indexWhere(
                        (task) => task.subtask == subTasksModel.subtask));
                  },
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

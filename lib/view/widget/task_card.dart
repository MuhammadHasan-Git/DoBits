import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/todo_list.dart';
import 'package:todo_app/view/widget/popup_button.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.task,
      required this.index,
      required this.mobileId});
  final String mobileId;
  final Task task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final RxList<SubTasksModel> todos =
        task.subTasks != null ? task.subTasks!.obs : <SubTasksModel>[].obs;

    String formattedDate = TaskController.formattedDate(
      dateString: task.date,
      dateFormate: 'E MMM d',
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.wp, left: 2.0.wp, right: 2.0.wp),
      child: Slidable(
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: task.isCompleted ? 0.5 : 0.3,
            children: [
              SizedBox(
                width: 3.0.wp,
              ),
              SlidableAction(
                onPressed: (context) => task.isCompleted
                    ? homeController.undoCompletedTask(
                        task.id,
                        mobileId,
                      )
                    : homeController.completeTask(task.id, mobileId),
                backgroundColor: task.isCompleted ? Colors.blue : Colors.green,
                icon: task.isCompleted ? Icons.undo : Icons.done,
                label: task.isCompleted ? null : "Finish",
                borderRadius: BorderRadius.circular(20),
              ),
              SizedBox(
                width: task.isCompleted ? 4.0.wp : 0,
              ),
              task.isCompleted
                  ? SlidableAction(
                      onPressed: (context) =>
                          homeController.deleteTask(task.id),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : const SizedBox(),
            ]),
        child: AnimatedOpacity(
          opacity: task.isCompleted ? 0.3 : 1,
          duration: const Duration(milliseconds: 600),
          child: AbsorbPointer(
            absorbing: task.isCompleted,
            child: SlideInLeft(
              duration: Duration(milliseconds: 500 * index),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Text(
                                task.category.name,
                                style: TextStyle(
                                  color: Color(
                                    task.category.color,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 1.0.wp,
                              ),
                              const VerticalDivider(
                                indent: 3,
                                endIndent: 3,
                              ),
                              SizedBox(
                                width: 1.0.wp,
                              ),
                              Text(
                                task.priority,
                                style: TextStyle(
                                  color: homeController
                                      .getPriorityColor(task.priority),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupButton(
                          task: task,
                          mobileId: mobileId,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.wp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.0.wp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: white,
                                    fontSize: 18,
                                  ),
                                ),
                                task.description != null
                                    ? Text(
                                        task.description!,
                                        softWrap: false,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: grey,
                                          fontSize: 14,
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: 1.5.wp,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.time,
                                          size: 14,
                                          color: grey,
                                        ),
                                        SizedBox(
                                          width: 1.0.wp,
                                        ),
                                        Text(
                                          TaskController.formatTime(
                                            time: DateTime.parse(task.time),
                                          ),
                                          style: const TextStyle(
                                              color: grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3.0.wp,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          size: 14,
                                          color: grey,
                                        ),
                                        SizedBox(
                                          width: 1.0.wp,
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: grey, fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        todos.isNotEmpty
                            ? GestureDetector(
                                onTap: () => Get.to(
                                    () => TodoListPage(
                                          id: task.id,
                                          mobileId: mobileId,
                                          title: task.title,
                                          category: TaskCategory(
                                            color: task.category.color,
                                            name: task.category.name,
                                          ),
                                        ),
                                    transition: Transition.downToUp),
                                child: CircularPercentIndicator(
                                  radius: 10.0.wp,
                                  animateFromLastPercent: true,
                                  animation: true,
                                  lineWidth: 5.0,
                                  percent: (todos
                                          .where((element) => element.done)
                                          .length /
                                      todos.length),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: Color(task.category.color)
                                      .withOpacity(0.1),
                                  center: Text(
                                    '${(todos.where((element) => element.done).length / todos.length * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Color(
                                        task.category.color,
                                      ),
                                    ),
                                  ),
                                  progressColor: Color(task.category.color),
                                ),
                              )
                            : const SizedBox()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

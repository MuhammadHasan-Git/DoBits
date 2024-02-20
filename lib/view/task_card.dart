import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/todo_list.dart';
import 'package:todo_app/view/widget/popup_button.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.snapshot});
  final AsyncSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return ListView.builder(
      itemCount: snapshot?.data != null ? snapshot?.data!.docs.length : 0,
      itemBuilder: (context, index) {
        DocumentSnapshot ds = snapshot?.data!.docs[index];
        final RxList<SubTasksModel> todos = List<SubTasksModel>.from(
            (ds['subTasks'] as List).map((e) => SubTasksModel.fromJson(e))).obs;

        String formattedDate = TaskController.formattedDate(
          dateString: ds['date'],
          dateFormate: 'E MMM d',
        );
        return Padding(
          padding: EdgeInsets.only(bottom: 8.0.wp),
          child: Slidable(
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.3,
                children: [
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Colors.blue,
                    icon: Icons.edit,
                    label: "Edit",
                    borderRadius: BorderRadius.circular(20),
                  ),
                ]),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              ds['categoryName'],
                              style: TextStyle(
                                color: Color(
                                  int.parse(
                                    ds['categoryColor'],
                                  ),
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
                              ds['priority'],
                              style: TextStyle(
                                color: homeController
                                    .getPriorityColor(ds['priority']),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupButton(ds: ds),
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
                                ds['title'],
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: white,
                                  fontSize: 18,
                                ),
                              ),
                              ds['description'] != null
                                  ? Text(
                                      ds['description'],
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
                                          time: DateTime.parse(ds['time']),
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
                                        id: ds.id,
                                        title: ds['title'],
                                        category: TaskCategory(
                                          color: int.parse(ds['categoryColor']),
                                          name: ds['categoryName'],
                                        ),
                                      ),
                                  transition: Transition.downToUp),
                              child: CircularPercentIndicator(
                                radius: 10.0.wp,
                                animateFromLastPercent: true,
                                animation: true,
                                lineWidth: 3.0,
                                percent: (todos
                                        .where((element) => element.done)
                                        .length /
                                    todos.length),
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor:
                                    Color(int.parse(ds['categoryColor']))
                                        .withOpacity(0.1),
                                center: Text(
                                  '${(todos.where((element) => element.done).length / todos.length * 100).toInt().toString()}%',
                                  style: TextStyle(
                                    color: Color(
                                      int.parse(ds['categoryColor']),
                                    ),
                                  ),
                                ),
                                progressColor:
                                    Color(int.parse(ds['categoryColor'])),
                              ),
                            )
                          : const SizedBox()
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

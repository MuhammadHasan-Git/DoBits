import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
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
                      SizedBox(
                        width: 16.0.wp,
                        height: 16.0.wp,
                        child: CircleProgressBar(
                          strokeWidth: 4,
                          foregroundColor: Color(
                            int.parse(
                              ds['categoryColor'],
                            ),
                          ),
                          value: 0.2,
                          backgroundColor: Color(int.parse(ds['categoryColor']))
                              .withOpacity(0.1),
                          child: const Center(
                              child: AnimatedCount(
                                  style: TextStyle(color: white),
                                  count: 1,
                                  unit: "%",
                                  duration: Duration(milliseconds: 500))),
                        ),
                      ),
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

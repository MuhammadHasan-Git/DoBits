import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

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
        return Container(
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
                            color:
                                homeController.getPriorityColor(ds['priority']),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: const Icon(
                      Icons.more_vert,
                      color: white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.5.wp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        ds['title'],
                        style: const TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 1.5.wp,
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 15,
                            color: white.withOpacity(0.5),
                          ),
                          SizedBox(
                            width: 1.0.wp,
                          ),
                          Text(
                            ds['time'],
                            style: TextStyle(
                              color: white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20.0.wp,
                    height: 20.0.wp,
                    child: CircleProgressBar(
                      foregroundColor: Color(
                        int.parse(
                          ds['categoryColor'],
                        ),
                      ),
                      value: 0.68,
                      backgroundColor: Color(int.parse(ds['categoryColor']))
                          .withOpacity(0.1),
                      child: const Center(
                          child: AnimatedCount(
                              style: TextStyle(color: white),
                              count: 0.68,
                              unit: "%",
                              duration: Duration(milliseconds: 500))),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

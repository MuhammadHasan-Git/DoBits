import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class TaskReport extends StatelessWidget {
  const TaskReport({
    super.key,
    required this.mobileId,
  });
  final String mobileId;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: FirebaseAuth.instance.currentUser!.isAnonymous
          ? firestore
              .collection("Guest")
              .doc(mobileId)
              .collection("Tasks")
              .snapshots()
          : firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .collection("Tasks")
              .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        final int totalTask = snapshot.data?.docs.length ?? 0;
        int? completedTask = snapshot.data != null
            ? (snapshot.data?.docs as List)
                .where((element) => element.data()!['isCompleted'] == true)
                .length
            : 0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.sp,
                            height: 8.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Total Task : $totalTask",
                            style: TextStyle(
                              color: white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.0.wp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.sp,
                            height: 8.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Live : ${totalTask - completedTask}",
                            style: TextStyle(
                              color: white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.0.wp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.sp,
                            height: 8.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Completed : $completedTask",
                            style: TextStyle(
                              color: white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: white,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: white.withOpacity(0.2),
                    animation: true,
                    animateFromLastPercent: true,
                    radius: 12.0.wp,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: totalTask == 0 ? 0 : completedTask / totalTask,
                    center: Text(
                      "${totalTask == 0 ? 0 : (completedTask / totalTask * 100).toStringAsFixed(0)} %",
                      style: const TextStyle(color: white),
                    ),
                    progressColor: const Color(0xFF7fff00),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

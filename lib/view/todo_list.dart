import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/todo_controller.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TodoListPage extends StatelessWidget {
  final String title;
  final TaskCategory category;
  final String id;
  const TodoListPage(
      {super.key,
      required this.title,
      required this.category,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.put(HomeController());
    final todoCtrl = Get.put(TodoControlelr());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.close,
            color: white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Sub Task List",
          style: TextStyle(color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 3.0.wp, left: 6.0.wp, right: 6.0.wp),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.currentUser!.isAnonymous
                ? firestore
                    .collection("Guest")
                    .doc(homeCtrl.mobileId)
                    .collection("Tasks")
                    .doc(id)
                    .snapshots()
                : firestore
                    .collection("Users")
                    .doc(auth.currentUser!.uid)
                    .collection("Tasks")
                    .doc(id)
                    .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Document does not exist'));
              }
              if (snapshot.hasData) {
                final ds = snapshot.data!.data();
                final RxList<SubTasksModel> todos = List<SubTasksModel>.from(
                    (ds['subTasks'] as List)
                        .map((e) => SubTasksModel.fromJson(e))).obs;
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 3.0.wp,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.0.wp, vertical: 1.0.wp),
                          decoration: BoxDecoration(
                              color: Color(category.color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            category.name,
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                color: Color(
                                  category.color,
                                )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3.0.wp,
                    ),
                    Row(
                      children: [
                        Text(
                          todos.length > 1
                              ? "${todos.length} Tasks"
                              : "${todos.length} Task",
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 3.0.wp,
                        ),
                        Expanded(
                          child: Obx(
                            () => LinearPercentIndicator(
                              // ignore: deprecated_member_use
                              linearStrokeCap: LinearStrokeCap.round,
                              animateFromLastPercent: true,
                              barRadius: const Radius.circular(30),
                              lineHeight: 14.0,
                              animation: true,
                              percent: (todos
                                      .where((element) => element.done)
                                      .length /
                                  todos.length),
                              backgroundColor:
                                  Color(category.color).withOpacity(0.1),
                              progressColor: Color(category.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0.wp,
                    ),
                    ListView.builder(
                      itemCount: todos.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        RxBool isChecked = todos[index].done.obs;
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SlideInRight(
                            duration: Duration(milliseconds: 350 * index),
                            child: Obx(
                              () => AnimatedOpacity(
                                opacity: isChecked.value ? 0.3 : 1,
                                duration: const Duration(milliseconds: 600),
                                child: Card(
                                  elevation: 10,
                                  color: white.withOpacity(0.1),
                                  surfaceTintColor: white.withOpacity(0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Transform.scale(
                                            scale: 1.2,
                                            child: Checkbox(
                                              checkColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              fillColor:
                                                  const MaterialStatePropertyAll(
                                                      black),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: isChecked.value,
                                              onChanged: (value) {
                                                todoCtrl.doneTodo(
                                                    id,
                                                    homeCtrl.mobileId,
                                                    value,
                                                    index,
                                                    todos[index].subtask);
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0.wp,
                                        ),
                                        Expanded(
                                          child: Text(
                                            todos[index].subtask,
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              decoration: isChecked.value
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationColor: white,
                                              decorationThickness: 1.5,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              color: white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/authentication/login_options.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Categories")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          final List<dynamic> categories = [...taskController.categories];
          categories.addAll(snapshot.data.docs.map((doc) {
            log(doc.id);
            return TaskCategory(color: doc['color'], name: doc['name']);
          }));

          return Wrap(
            spacing: 2.0.wp,
            children: List.generate(
              categories.length + 1,
              (index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                        Get.to(
                            () => const LoginOptions(
                                  isGuest: true,
                                ),
                            transition: Transition.downToUp);
                      } else {
                        taskController.dialogBuilder(context);
                      }
                    },
                    splashFactory: NoSplash.splashFactory,
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 120,
                      height: 36,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 20,
                            color: white,
                          ),
                          Text(
                            "Add Category",
                            style: TextStyle(
                              fontSize: 12,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  final adjustedIndex = index - 1;
                  final category = categories[adjustedIndex];

                  return GestureDetector(
                    onTap: () => taskController.chipIndex.value = adjustedIndex,
                    onLongPress: () {
                      log(adjustedIndex.toString());
                      if (index - 1 > 6 && snapshot.data != null) {
                        DocumentSnapshot ds =
                            snapshot.data!.docs[adjustedIndex];
                        taskController.deleteCategory(adjustedIndex, ds.id);
                      }
                    },
                    child: Obx(
                      () => Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(category.color),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          side: BorderSide(
                              color: taskController.chipIndex.value ==
                                      adjustedIndex
                                  ? Color(category.color)
                                  : Colors.transparent,
                              width: taskController.chipIndex.value ==
                                      adjustedIndex
                                  ? 2
                                  : 0),
                          color: MaterialStatePropertyAll(
                            Color(category.color).withOpacity(0.15),
                          )),
                    ),
                  );
                }
              },
            ),
          );
        });
  }
}

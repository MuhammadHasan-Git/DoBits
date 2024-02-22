import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/view/task_card.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final homeControler = Get.put(HomeController());
    UserController userController = Get.put(UserController());
    return FutureBuilder(
        future: userController.getId(),
        builder: (_, mobileIdSnapShot) {
          if (mobileIdSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (mobileIdSnapShot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          if (mobileIdSnapShot.hasData) {
            log(mobileIdSnapShot.data.toString());
            return StreamBuilder(
                stream: FirebaseAuth.instance.currentUser!.isAnonymous
                    ? firestore
                        .collection("Guest")
                        .doc(mobileIdSnapShot.data)
                        .collection("Tasks")
                        .snapshots()
                    : firestore
                        .collection("Users")
                        .doc(auth.currentUser!.uid)
                        .collection("Tasks")
                        .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return TaskCard(
                      snapshot: snapshot,
                      mobileId: mobileIdSnapShot.data ?? '',
                    );
                  } else {
                    return const SizedBox();
                  }
                });
          }
          return const SizedBox.shrink();
        });
  }
}

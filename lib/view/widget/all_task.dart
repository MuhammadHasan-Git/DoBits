import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/view/task_card.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final homeControler = Get.put(HomeController());

    return StreamBuilder(
        stream: FirebaseAuth.instance.currentUser!.isAnonymous
            ? firestore
                .collection("Guest")
                .doc(homeControler.mobileId)
                .collection("Tasks")
                .snapshots()
            : firestore
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection("Tasks")
                .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return TaskCard(
            snapshot: snapshot,
          );
        });
  }
}

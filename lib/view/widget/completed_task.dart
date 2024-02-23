import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/widget/task_list.dart';

class CompletedTask extends StatelessWidget {
  const CompletedTask({super.key, required this.mobileId});
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
                .orderBy('createdOn')
                .where(
                  'isCompleted',
                  isEqualTo: true,
                )
                .snapshots()
            : firestore
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection("Tasks")
                .orderBy('createdOn')
                .where('isCompleted', isEqualTo: true)
                .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data.docs.isEmpty) {
            return Center(
              child: Text(
                'No Completed Task',
                style: TextStyle(color: white, fontSize: 16.sp),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: white),
              ),
            );
          } else if (snapshot.hasData) {
            return TaskList(
              snapshot: snapshot,
              mobileId: mobileId,
            );
          }
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: white),
            ),
          );
        });
  }
}

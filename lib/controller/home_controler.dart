import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utils/colors.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  // late final String? mobileId;O

  // @override
  // Future<void> onInit() async {

  //   // mobileId = await UserController.getId();
  //   super.onInit();
  // }

  Future<dynamic> alertDialog(DocumentSnapshot ds) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: black,
        surfaceTintColor: black,
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Delete this task",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure! you want to delete this task",
          style: TextStyle(color: white),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                final taskController = Get.put(TaskController());
                taskController.deleteTask(ds.id);
              }),
        ],
      ),
    );
  }

  completeTask(String docId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
          ? firestore
              .collection("Guest")
              .doc(mobileId)
              .collection("Tasks")
              .doc(docId)
          : firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .collection("Tasks")
              .doc(docId);

      DocumentSnapshot documentSnapshot = await taskRef.get();
      List<Map<String, dynamic>> existingList =
          List.from(documentSnapshot.get('subTasks'));
      for (var element in existingList) {
        element['done'] = true;
      }

      await taskRef.update({'isCompleted': true, 'subTasks': existingList});

      Fluttertoast.showToast(
          msg: "Task Completed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseAuthException {
      Fluttertoast.showToast(
          msg: "Failed to complete task",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  undoCompletedTask(String docId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
          ? firestore
              .collection("Guest")
              .doc(mobileId)
              .collection("Tasks")
              .doc(docId)
          : firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .collection("Tasks")
              .doc(docId);

      DocumentSnapshot documentSnapshot = await taskRef.get();
      List<Map<String, dynamic>> existingList =
          List.from(documentSnapshot.get('subTasks'));
      for (var element in existingList) {
        element['done'] = false;
      }

      await taskRef.update({
        'isCompleted': false,
        'subTasks': existingList,
        'createdOn': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
          msg: "Task Recreated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseAuthException {
      Fluttertoast.showToast(
          msg: "Failed to recreate task",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Color? getPriorityColor(value) {
    switch (value) {
      case "Low Priority":
        return Colors.green;
      case "Medium Priority":
        return Colors.orange;
      case "High Priority":
        return Colors.red;

      default:
        return null;
    }
  }
}

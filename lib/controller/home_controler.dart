import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class HomeController extends GetxController {
  final userCtrl = Get.find<UserController>();
  RxInt index = 0.obs;
  late final String? mobileId;

  @override
  Future<void> onInit() async {
    mobileId = await UserController.getId();
    super.onInit();
  }

  static void customLoadingDialog(String text) {
    Get.dialog(
      barrierDismissible: false,
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Dialog(
          backgroundColor: black,
          surfaceTintColor: black,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0.wp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(
                  color: blue,
                  size: 15.0.wp,
                ),
                SizedBox(height: 6.0.wp),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteTask(String id) async {
    try {
      final taskRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Tasks")
          .doc(id);
      await taskRef.delete();
      Get.back();
      Fluttertoast.showToast(
          msg: "Task has been deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to delete task",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<dynamic> alertDialog(id) {
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
              onPressed: () => deleteTask(id)),
        ],
      ),
    );
  }

  completeTask(String docId) async {
    try {
      customLoadingDialog("Processing");
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
      Get.back();

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
      customLoadingDialog("Processing");
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
      Get.back();

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

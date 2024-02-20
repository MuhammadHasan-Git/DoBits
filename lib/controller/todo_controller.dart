import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TodoControlelr extends GetxController {
  doneTodo(String id, String? mobileID, bool? value, int index,
      String subtask) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
          ? firestore
              .collection("Guest")
              .doc(mobileID)
              .collection("Tasks")
              .doc(id)
          : firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .collection("Tasks")
              .doc(id);
      DocumentSnapshot documentSnapshot = await taskRef.get();

      List<Map<String, dynamic>> existingList =
          List.from(documentSnapshot.get('subTasks'));

      Map<String, dynamic> newMap = {
        'subtask': subtask,
        'done': value,
      };
      existingList.removeAt(index);
      existingList.insert(index, newMap);

      await taskRef.update({'subTasks': existingList});

      Fluttertoast.showToast(
          msg: value!
              ? "Subtask Completed successfully!"
              : "Subtask Marked as Incomplete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseAuthException {
      Fluttertoast.showToast(
          msg: "Failed to update subtask status",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

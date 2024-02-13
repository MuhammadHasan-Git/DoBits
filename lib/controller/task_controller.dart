import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/widget/dialog_content.dart';

class TaskController extends GetxController {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }

  RxList<TaskCategory> categories = [
    TaskCategory(
      name: 'Personal',
      color: 0xff42A5F5,
    ),
    TaskCategory(
      name: 'Work',
      color: 0xff607D8B,
    ),
    TaskCategory(
      name: 'Sports',
      color: 0xff4CAF50,
    ),
    TaskCategory(
      name: 'Study',
      color: 0xffFF9800,
    ),
    TaskCategory(
      name: 'Health',
      color: 0xffF44336,
    ),
    TaskCategory(
      name: 'Entertainment',
      color: 0xff41CF9F,
    ),
    TaskCategory(
      name: 'Finance',
      color: 0xff3F51B5,
    ),
  ].obs;

  String formattedDate = "";
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  RxString selectedPriority = 'Low Priority'.obs;
  RxBool isRemind = true.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateInput = TextEditingController(
    text: DateFormat('E, MMM d yyyy').format(DateTime.now()),
  );
  final startTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 14, minute: 0)));
  final endTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 17, minute: 0)));
  final categoryName = TextEditingController();

  final chipIndex = 0.obs;

  Rx<int> selectedColor = 0xff778CDD.obs;
  RxInt buttonIndex = 0.obs;

  void addCategory(String name, Rx<int> color, context) {
    categories.add(TaskCategory(color: color.value, name: name));
    Navigator.of(context).pop();
    selectedColor.value = 0xff778CDD;
    buttonIndex.value = 0;
    categoryName.clear();
  }

  deleteCategory(index) {
    if (index > 6) {
      categories.remove(categories[index]);
    } else {
      null;
    }
  }

  createCategory(TaskCategory category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
        ? firestore
            .collection("Guest")
            .doc(await UserController.getId())
            .collection("Categories")
            .doc()
        : firestore
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .collection("Categories")
            .doc();
    try {
      await taskRef.set({
        'name': category.name,
        'color': category.color,
      });
      Fluttertoast.showToast(
          msg: "Category created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseAuthException {
      Fluttertoast.showToast(
          msg: "Failed to create category",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future displayDatePicker(BuildContext context) async {
    final initialDate = selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: darkBlue,
                ),
              ),
              colorScheme: const ColorScheme.dark(
                onSurface: blue,
                primary: black,
                onPrimary: darkBlue,
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      selectedDate = pickedDate;
      formattedDate = DateFormat('E, MMM d yyyy').format(pickedDate);
      dateInput.text = formattedDate;
    } else {}
  }

  Future displayTimePicker(
      BuildContext context, TextEditingController timeInput, int index) async {
    TimeOfDay? initialTime;
    if (index == 1) {
      initialTime = selectedStartTime ?? TimeOfDay.now();
    } else {
      initialTime = selectedEndTime ?? TimeOfDay.now();
    }
    TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (pickedTime != null) {
      if (index == 1) {
        selectedStartTime = pickedTime;
      } else {
        selectedEndTime = pickedTime;
      }
      timeInput.text = formatTime(pickedTime);
    }
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: black,
          surfaceTintColor: black,
          title: const Text(
            'Create Category',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            color: white,
            fontSize: 24,
          ),
          content: const DialogContent(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: darkBlue),
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
                selectedColor.value = 0xff778CDD;
                buttonIndex.value = 0;
                categoryName.clear();
              },
            ),
            TextButton(
                style: TextButton.styleFrom(foregroundColor: darkBlue),
                child: const Text('Create'),
                onPressed: () {
                  final category = TaskCategory(
                      color: selectedColor.value, name: categoryName.text);
                  createCategory(category);
                }),
          ],
        );
      },
    );
  }

  Future<void> createTask({
    required BuildContext context,
    required String title,
    required String date,
    String? description,
    required String startTime,
    required String endTime,
    required TaskCategory category,
    required String priority,
    required bool isRemind,
    required List<String> subTasks,
  }) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: darkBlue,
                  ),
                  SizedBox(
                    height: 3.0.wp,
                  ),
                  const Text(
                    "Creating...",
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ));
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
        ? firestore
            .collection("Guest")
            .doc(await UserController.getId())
            .collection("Tasks")
            .doc()
        : firestore
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .collection("Tasks")
            .doc();
    final task = Task(
      id: taskRef.id,
      title: title,
      date: date,
      description: description,
      startTime: startTime,
      endTime: endTime,
      category: category,
      priority: priority,
      isRemind: isRemind,
      subTasks: subTasks,
      createdOn: FieldValue.serverTimestamp(),
    );

    try {
      await taskRef.set({
        'id': taskRef.id,
        'createdOn': task.createdOn,
        'title': task.title,
        'date': task.date,
        'description': task.description,
        'startTime': task.startTime,
        'endTime': task.endTime,
        'categoryName': task.category.name,
        'categoryColor': task.category.color.toString(),
        'priority': task.priority,
        'isRemind': task.isRemind,
        'subTasks': task.subTasks,
      });
      await Fluttertoast.showToast(
          msg: "Task created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseAuthException {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Fluttertoast.showToast(
          msg: "Failed to create task",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

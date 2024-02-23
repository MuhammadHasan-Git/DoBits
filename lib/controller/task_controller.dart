import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/sub_task.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/services/shared_preferences_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/widget/dialog_content.dart';

class TaskController extends GetxController {
  final Task? editTaskModel;
  TaskController({this.editTaskModel});
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> categoryKey = GlobalKey<FormState>();
  late final String? mobileId;
  DateTime? selectedDate = DateTime.now();
  DateTime? selectedTime;

  static String formattedDate(
      {String? dateFormate = 'E, MMM d yyyy', required String dateString}) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat(dateFormate).format(date);
    return formattedDate;
  }

  static String formatTime(
      {required DateTime time, String? dateFormate = 'hh:mm a'}) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(dateFormate).format(dateTime);
  }

  List<TaskCategory> defaultCategories = [
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

  RxString selectedPriority = 'Low Priority'.obs;
  RxBool isRemind = true.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateInput = TextEditingController();

  final timeInput = TextEditingController();

  final categoryName = TextEditingController();

  RxList<dynamic> categories = <dynamic>[].obs;

  final chipIndex = 0.obs;

  Rx<int> selectedColor = 0xff778CDD.obs;
  RxInt buttonIndex = 0.obs;

  deleteCategory(int index, id) async {
    if (index > 6) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Categories")
          .doc(id)
          .delete();
    } else {
      null;
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
                  if (categoryKey.currentState!.validate()) {
                    final category = TaskCategory(
                        color: selectedColor.value, name: categoryName.text);
                    createCategory(category);
                  }
                }),
          ],
        );
      },
    );
  }

  createCategory(TaskCategory category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final taskRef = firestore
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Categories")
        .doc();
    try {
      await taskRef.set({
        'name': category.name,
        'color': category.color,
        'createdOn': category.createdOn,
      }).then((_) {
        Get.back();
        categoryName.clear();
        selectedColor.value = 0xff778CDD;
        buttonIndex.value = 0;
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

  String? categoryFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter category name';
    } else {
      return null;
    }
  }

  Future displayDatePicker(BuildContext context) async {
    final initialDate = selectedDate;
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
    if (pickedDate != null && pickedDate.isBefore(DateTime.now())) {
      await Fluttertoast.showToast(
          msg: "Task date cannot be in past",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (pickedDate != null) {
      {
        selectedDate = pickedDate;
        dateInput.text =
            formattedDate(dateString: pickedDate.toIso8601String());
      }
    }
  }

  Future displayTimePicker(
      BuildContext context, TextEditingController timeInput) async {
    TimeOfDay? initialTime;

    initialTime =
        TimeOfDay(hour: selectedTime!.hour, minute: selectedTime!.minute);

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: blue,
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
    );
    if (pickedTime != null) {
      selectedTime = timeOfDayToDateTime(pickedTime);
      timeInput.text = formatTime(time: timeOfDayToDateTime(pickedTime));
    }
  }

  Future<void> createTask({required final Task taskModel}) async {
    HomeController.customLoadingDialog("Creating Task...");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
        ? firestore.collection("Guest").doc(mobileId).collection("Tasks").doc()
        : firestore
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .collection("Tasks")
            .doc();

    if (taskModel.isRemind) {
      NotificationServices().zonedScheduleNotification(
        title: '👋DoBits!',
        selectedTime: DateTime.parse(taskModel.time),
        body: taskModel.title,
      );
    }
    try {
      await taskRef.set({
        'id': taskRef.id,
        'createdOn': taskModel.createdOn,
        'title': taskModel.title,
        'date': taskModel.date,
        'description': taskModel.description,
        'time': taskModel.time,
        'categoryName': taskModel.category.name,
        'categoryColor': taskModel.category.color.toString(),
        'priority': taskModel.priority,
        'isRemind': taskModel.isRemind,
        'subTasks': taskModel.subTasks?.map((e) => e.toJson()),
        'isCompleted': false,
        'milliseconds': DateTime.parse(taskModel.date).millisecondsSinceEpoch,
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

  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  @override
  void onInit() async {
    final subTaskController = Get.put(SubTaskController());

    mobileId = SharedPreferencesService.getData('guestId').toString();
    titleController.text = editTaskModel?.title ?? '';
    dateInput.text = editTaskModel?.date != null
        ? formattedDate(dateString: editTaskModel!.date)
        : DateFormat('E, MMM d yyyy').format(DateTime.now());
    selectedDate = editTaskModel?.date != null
        ? DateTime.parse(editTaskModel!.date)
        : DateTime.now();
    timeInput.text = formatTime(
        time: editTaskModel?.time != null
            ? DateTime.parse(editTaskModel!.time)
            : DateTime.now());
    selectedTime = editTaskModel?.time != null
        ? DateTime.parse(editTaskModel!.time)
        : DateTime.now();
    descriptionController.text = editTaskModel?.description ?? '';
    if (editTaskModel?.subTasks != null) {
      for (var i = 0; i < editTaskModel!.subTasks!.length; i++) {
        subTaskController.getSubtask(
            SubTasksModel(
                subtask: editTaskModel!.subTasks![i].subtask,
                done: editTaskModel!.subTasks![i].done),
            i);
      }
    }
    selectedPriority.value = editTaskModel?.priority ?? 'Low Priority';
    isRemind.value = editTaskModel?.isRemind ?? true;
    super.onInit();
  }

  updateTask(Task updateTaskModel) async {
    try {
      HomeController.customLoadingDialog("Updating Task...");
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final taskRef = FirebaseAuth.instance.currentUser!.isAnonymous
          ? firestore
              .collection("Guest")
              .doc(mobileId)
              .collection("Tasks")
              .doc(updateTaskModel.id)
          : firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .collection("Tasks")
              .doc(updateTaskModel.id);

      await taskRef.update({
        'updatedOn': Timestamp.now(),
        'title': updateTaskModel.title,
        'date': updateTaskModel.date,
        'description': updateTaskModel.description,
        'time': updateTaskModel.time,
        'categoryName': updateTaskModel.category.name,
        'categoryColor': updateTaskModel.category.color.toString(),
        'priority': updateTaskModel.priority,
        'isRemind': updateTaskModel.isRemind,
        'subTasks': updateTaskModel.subTasks!.map((e) => e.toJson()),
        'milliseconds':
            DateTime.parse(updateTaskModel.date).millisecondsSinceEpoch,
      });
      if (updateTaskModel.isRemind) {
        NotificationServices().zonedScheduleNotification(
          title: '👋DoBits!',
          selectedTime: DateTime.parse(updateTaskModel.time),
          body: updateTaskModel.title,
        );
      }
      Fluttertoast.showToast(
          msg: "Task updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Fluttertoast.showToast(
          msg: "Failed to update task",
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

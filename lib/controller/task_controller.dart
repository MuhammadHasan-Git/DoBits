import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/controller/sub_task.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/edit_task_model.dart';
import 'package:todo_app/model/sub_tasks.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/model/update_task.dart';
import 'package:todo_app/utils/colors.dart';

class TaskController extends GetxController {
  final EditTaskModel? editTaskModel;
  TaskController({this.editTaskModel});
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> categoryKey = GlobalKey<FormState>();
  late final String? mobileId;
  DateTime? selectedDate;
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

  RxList categories = [].obs;

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
    if (pickedDate != null) {
      selectedDate = pickedDate;
      dateInput.text = formattedDate(dateString: pickedDate.toIso8601String());
    } else {}
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

  Future<void> createTask({
    required BuildContext context,
    required String title,
    String? description,
    required TaskCategory category,
    required String priority,
    required bool isRemind,
    required List<SubTasksModel>? subTasks,
  }) async {
    HomeController.customLoadingDialog("Creating Task...");
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
        date:
            selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        description: description == '' ? null : description,
        time: selectedTime?.toIso8601String() ??
            timeOfDayToDateTime(TimeOfDay.now()).toIso8601String(),
        category: category,
        priority: priority,
        isRemind: isRemind,
        subTasks: subTasks?.toList(),
        createdOn: Timestamp.now(),
        isCompleted: false);

    try {
      await taskRef.set({
        'id': taskRef.id,
        'createdOn': task.createdOn,
        'title': task.title,
        'date': task.date,
        'description': task.description,
        'time': task.time,
        'categoryName': task.category.name,
        'categoryColor': task.category.color.toString(),
        'priority': task.priority,
        'isRemind': task.isRemind,
        'subTasks': subTasks?.map((e) => e.toJson()),
        'isCompleted': false,
        'milliseconds': DateTime.parse(task.date).millisecondsSinceEpoch,
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
    mobileId = await UserController.getId();
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
    if (editTaskModel!.subtasks != null) {
      for (var i = 0; i < editTaskModel!.subtasks!.length; i++) {
        subTaskController.getSubtask(
            SubTasksModel(
                subtask: editTaskModel!.subtasks![i].subtask,
                done: editTaskModel!.subtasks![i].done),
            i);
      }
    }
    selectedPriority.value = editTaskModel?.priorities ?? 'Low Priority';
    isRemind.value = editTaskModel?.isRemind ?? true;
    super.onInit();
  }

  updateTask(UpdateTaskModel updateTaskModel, context) async {
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

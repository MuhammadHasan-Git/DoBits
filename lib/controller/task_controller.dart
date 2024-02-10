import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/widget/dialog_content.dart';

class TaskController extends GetxController {
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }

  RxList<TaskCategory> categories = [
    TaskCategory(
      name: 'Personal',
      color: const Color(0xff42A5F5),
    ),
    TaskCategory(
      name: 'Work',
      color: const Color(0xff607D8B),
    ),
    TaskCategory(
      name: 'Sports',
      color: const Color(0xff4CAF50),
    ),
    TaskCategory(
      name: 'Study',
      color: const Color(0xffFF9800),
    ),
    TaskCategory(
      name: 'Health',
      color: const Color(0xffF44336),
    ),
    TaskCategory(
      name: 'Entertainment',
      color: const Color(0xff41CF9F),
    ),
    TaskCategory(
      name: 'Finance',
      color: const Color(0xff3F51B5),
    ),
  ].obs;

  String formattedDate = "";
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  RxString selectedPriority = 'Low Priority'.obs;
  RxBool isRemind = true.obs;

  final titleController = TextEditingController();
  final dateInput = TextEditingController(
    text: DateFormat('E, MMM d yyyy').format(DateTime.now()),
  );
  final startTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 14, minute: 0)));
  final endTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 17, minute: 0)));
  final categoryName = TextEditingController();

  final chipIndex = 0.obs;

  Rx<Color> selectedColor = Colors.transparent.obs;
  RxInt buttonIndex = 0.obs;

  addCategory(String name, Rx<Color> color, context) {
    categories.add(TaskCategory(color: color.value, name: name));
    Navigator.of(context).pop();
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

  Future displayDatePicker(BuildContext context) async {
    final initialDate = selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: darkBlue, // button text color
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
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: darkBlue),
              child: const Text('Create'),
              onPressed: () =>
                  addCategory(categoryName.text, selectedColor, context),
            ),
          ],
        );
      },
    );
  }
}

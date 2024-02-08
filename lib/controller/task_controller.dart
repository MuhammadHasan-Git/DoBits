import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }

  String formattedDate = "";
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  final titleController = TextEditingController();
  final dateInput = TextEditingController(
    text: DateFormat('E, MMM d yyyy').format(DateTime.now()),
  );
  final startTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 14, minute: 0)));
  final endTimeInput = TextEditingController(
      text: formatTime(const TimeOfDay(hour: 17, minute: 0)));
  final chipIndex = 0.obs;

  Future displayDatePicker(BuildContext context) async {
    final initialDate = selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
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
}

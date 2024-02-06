import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(GetMaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: black),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

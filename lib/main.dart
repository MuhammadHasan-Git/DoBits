import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/authentication/auth.dart';
import 'package:todo_app/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(GetMaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: black,
      dialogBackgroundColor: black,
      navigationBarTheme: const NavigationBarThemeData(
          labelTextStyle: MaterialStatePropertyAll(TextStyle(color: darkBlue))),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
      ),
    ),
    debugShowCheckedModeBanner: false,
    builder: FToastBuilder(),
    navigatorKey: navigatorKey,
    home: const Auth(),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return Obx(
      () => Scaffold(
        body: const HomePage(),
        bottomNavigationBar: NavigationBar(
          backgroundColor: black,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          elevation: 0,
          onDestinationSelected: (int index) {
            homeController.index.value = index;
          },
          indicatorColor: darkBlue.withOpacity(0.2),
          selectedIndex: homeController.index.value,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: darkBlue,
              ),
              icon: Icon(
                Icons.home_outlined,
                color: Colors.grey,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.task_alt,
                color: darkBlue,
              ),
              icon: Icon(
                Icons.task_alt,
                color: Colors.grey,
              ),
              label: 'Tasks',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.bar_chart_rounded,
                color: darkBlue,
              ),
              icon: Icon(
                Icons.bar_chart_rounded,
                color: Colors.grey,
              ),
              label: 'Insight',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                color: darkBlue,
              ),
              icon: Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

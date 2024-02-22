import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:todo_app/controller/home_controler.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/authentication/login_options.dart';
import 'package:todo_app/view/home_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  tz.initializeTimeZones();
  final timeZoneName = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(timeZoneName));
  NotificationServices().initNotification();
  // Get.put(NotificationServices());
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "reminder_channel_group_key",
      channelKey: "reminder_channel_key",
      channelName: "Reminder Notifications",
      channelDescription: "Reminder Notifications for tasks",
    ),
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  // FirebaseAuth.instance.signOut();
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
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something Went Wrong!"),
          );
        }
        if (snapshot.hasData) {
          return const MyApp();
        } else {
          return const LoginOptions();
        }
      },
    ),
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

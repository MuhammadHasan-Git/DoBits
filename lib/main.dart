import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/services/shared_preferences_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/authentication/login_options.dart';
import 'package:todo_app/view/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.init();
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

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: black,
            dialogBackgroundColor: black,
            navigationBarTheme: const NavigationBarThemeData(
                labelTextStyle:
                    MaterialStatePropertyAll(TextStyle(color: darkBlue))),
            appBarTheme: const AppBarTheme(
              backgroundColor: black,
            ),
          ),
          debugShowCheckedModeBanner: false,
          builder: FToastBuilder(),
          navigatorKey: navigatorKey,
          home: const MyApp(),
        );
      },
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          return HomePage(
            mobileId: SharedPreferencesService.getData('guestId').toString(),
          );
        } else {
          return const LoginOptions();
        }
      },
    );
  }
}

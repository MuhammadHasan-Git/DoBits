import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/services/shared_preferences_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/authentication/login_options.dart';
import 'package:todo_app/view/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {
      return GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: black,
          dialogBackgroundColor: black,
          textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
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
  ));
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
          return const HomePage();
        } else {
          return const LoginOptions();
        }
      },
    );
  }
}

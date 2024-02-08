import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/utils/colors.dart';
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
        appBarTheme: const AppBarTheme(
          backgroundColor: black,
        )),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final homeController = Get.put(HomeController());
//     return Obx(
//       () => Scaffold(
//         body: const HomePage(),
//         bottomNavigationBar: Theme(
//           data: ThemeData(
//               splashFactory: NoSplash.splashFactory,
//               splashColor: black,
//               bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//                 selectedItemColor: blue,
//                 unselectedItemColor: Colors.grey,
//                 backgroundColor: black,
//                 elevation: 0,
//               )),
//           child: BottomNavigationBar(
//             currentIndex: homeController.index.value,
//             onTap: (value) {
//               homeController.index.value = value;
//             },
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_month),
//                 label: 'Camera',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

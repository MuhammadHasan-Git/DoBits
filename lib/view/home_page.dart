import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/services/shared_preferences_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/add_task.dart';
import 'package:todo_app/view/widget/task_report.dart';
import 'package:todo_app/view/widget/task_tab.dart';

class HomePage extends StatelessWidget {
  final String mobileId;
  const HomePage({super.key, required this.mobileId});

  @override
  Widget build(BuildContext context) {
    final double width = Get.width;
    return Scaffold(
      backgroundColor: blue,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      UserController.getProfileImage(),
                      SizedBox(
                        width: 2.0.wp,
                      ),
                      Text(
                        'Welcome! ${FirebaseAuth.instance.currentUser!.displayName != null ? FirebaseAuth.instance.currentUser?.displayName : (FirebaseAuth.instance.currentUser!.isAnonymous ? 'Anonymous' : SharedPreferencesService.getData('username'))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: white,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 2.0.wp,
                  ),
                  IconButton(
                    onPressed: () => UserController.signOut(),
                    style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 8.0.wp,
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: width * 0.35,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              color: blue,
            ),
            child: TaskReport(mobileId: mobileId),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TaskBarView(mobileId: mobileId),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: blue,
        tooltip: 'Add Task',
        onPressed: () => Get.to(() => const AddTaskPage(),
            transition: Transition.rightToLeft),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

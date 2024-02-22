
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';

import '../../../controller/user_controller.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Center(
      child: FittedBox(
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => userController.loginWithGoogle(context),
          child: Container(
            width: Get.width * 0.7,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(color: white.withOpacity(0.35)),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/google_logo.png",
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Continue With Google",
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

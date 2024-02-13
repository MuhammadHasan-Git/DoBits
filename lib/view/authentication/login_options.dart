import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/authentication/login_view.dart';
import 'package:todo_app/view/authentication/signup_view.dart';
import 'package:todo_app/view/authentication/widgets/google_signin.dart';
import 'package:todo_app/view/widget/button.dart';
import '../../controller/auth_controller.dart';

class LoginOptions extends StatelessWidget {
  final bool? isGuest;
  const LoginOptions({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isGuest!
                    ? Row(
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.close,
                                color: white,
                              )),
                        ],
                      )
                    : const SizedBox(),
                SvgPicture.asset(
                  'assets/images/login-illustrator.svg',
                  alignment: Alignment.topCenter,
                  height: 300,
                  width: double.infinity,
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: darkBlue,
                    letterSpacing: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(
                  height: 10.0.wp,
                ),
                CustomButton(
                  text: "Login",
                  onPressed: () => Get.to(
                      () => Obx(() => authController.showSignIn.value
                          ? LoginView(
                              toggleView: () => authController.toggleView())
                          : SignupView(
                              toggleView: () => authController.toggleView())),
                      transition: Transition.downToUp),
                ),
                SizedBox(
                  height: 6.0.wp,
                ),
                CustomButton(
                  text: "Signup",
                  onPressed: () => Get.to(
                      () => Obx(() => authController.showSignIn.value
                          ? LoginView(
                              toggleView: () => authController.toggleView())
                          : SignupView(
                              toggleView: () => authController.toggleView())),
                      transition: Transition.downToUp),
                ),
                SizedBox(
                  height: 10.0.wp,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: white.withOpacity(0.5),
                      indent: 25,
                    )),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    const Text(
                      "OR",
                      style: TextStyle(color: white),
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Expanded(
                        child: Divider(
                      color: white.withOpacity(0.5),
                      endIndent: 25,
                    )),
                  ],
                ),
                SizedBox(
                  height: 10.0.wp,
                ),

                // ),
                const GoogleSignInButton(),
                SizedBox(
                  height: 15.0.wp,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Login as",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 4),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              final authController = Get.put(AuthController());
                              authController.toggleView();
                            },
                          text: "Guest",
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

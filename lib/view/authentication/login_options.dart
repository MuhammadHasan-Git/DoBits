import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/authentication/login_view.dart';
import 'package:todo_app/view/authentication/signup_view.dart';
import 'package:todo_app/view/authentication/widgets/google_signin.dart';
import 'package:todo_app/view/authentication/widgets/guest_signin.dart';
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
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 20,
          ),
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
                FadeInDown(
                  duration: const Duration(milliseconds: 1500),
                  child: SvgPicture.asset(
                    'assets/images/login-illustrator.svg',
                    alignment: Alignment.topCenter,
                    height: 300,
                    width: double.infinity,
                  ),
                ),
                Text(
                  isGuest! ? "LogIn to Access This Feature" : "Sign In Options",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkBlue,
                    letterSpacing: 2,
                    fontSize: isGuest! ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 1.0.wp,
                ),
                Text(
                  isGuest!
                      ? "To access this feature, please log in to your account."
                      : "Choose Your Preferred Sign-In Method",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: grey,
                    letterSpacing: 1,
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(
                  height: 10.0.wp,
                ),
                Bounce(
                  duration: const Duration(milliseconds: 1500),
                  child: CustomButton(
                    text: "Login",
                    onPressed: () => Get.to(
                        () => Obx(
                              () => authController.showSignIn.value
                                  ? LoginView(
                                      toggleView: () =>
                                          authController.toggleView())
                                  : SignupView(
                                      toggleView: () =>
                                          authController.toggleView()),
                            ),
                        transition: Transition.downToUp),
                  ),
                ),
                SizedBox(
                  height: 10.0.wp,
                ),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: grey,
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
                    const Expanded(
                        child: Divider(
                      color: grey,
                      endIndent: 25,
                    )),
                  ],
                ),
                SizedBox(
                  height: 10.0.wp,
                ),
                SlideInLeft(
                  duration: const Duration(milliseconds: 1500),
                  child: const GoogleSignInButton(),
                ),
                SizedBox(
                  height: 5.0.wp,
                ),
                SlideInRight(
                  duration: const Duration(milliseconds: 1500),
                  child: const GuestSignInButton(),
                ),
                SizedBox(
                  height: 15.0.wp,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account?",
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
                              Get.to(
                                  () => Obx(
                                        () => authController.showSignIn.value
                                            ? LoginView(
                                                toggleView: () =>
                                                    authController.toggleView())
                                            : SignupView(
                                                toggleView: () => authController
                                                    .toggleView()),
                                      ),
                                  transition: Transition.downToUp);
                            },
                          text: "Sign Up",
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

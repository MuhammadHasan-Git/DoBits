import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/authentication/widgets/text_field.dart';
import 'package:todo_app/view/home_page.dart';
import 'package:todo_app/view/widget/button.dart';

class LoginView extends StatelessWidget {
  final Function toggleView;
  const LoginView({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final userController = Get.put(UserController());
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 10),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 30,
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 1.0.wp,
                  ),
                  Text(
                    "Signin to your account",
                    style: TextStyle(
                      fontSize: 16,
                      color: white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AuthTextField(
                    hintText: "Enter your Email",
                    icon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    obscureText: false,
                    validator: (value) {
                      return authController.emailValidator(value);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => AuthTextField(
                      hintText: "Enter your password",
                      icon: const Icon(Icons.lock),
                      controller: passController,
                      obscureText: authController.isVisibleLogin.value,
                      onchanged: (value) {
                        if (value.isNotEmpty) {
                          authController.isEmptyLogin.value = false;
                        } else {
                          authController.isEmptyLogin.value = true;
                        }
                      },
                      suffixIcon: authController.isEmptyLogin.value
                          ? null
                          : IconButton(
                              splashRadius: 1,
                              icon: Icon(
                                authController.isVisibleLogin.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 25,
                              ),
                              onPressed: () => authController.isVisibleLogin
                                  .value = !authController.isVisibleLogin.value,
                            ),
                      validator: (String? value) {
                        return authController.passValidator(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4.0.wp,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0.wp,
                  ),
                  CustomButton(
                      text: "Log In",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          userController.signIn(
                              emailController, passController, context);
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: white.withOpacity(0.5),
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
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()));
                      try {
                        final user = await userController.loginWithGoogle();
                        if (user != null) {
                          userController.createUser(
                              user.displayName!, user.email!);
                          Get.to(() => const HomePage());
                        } else {}
                      } on FirebaseAuthException catch (error) {
                        log(error.message.toString());
                        if (error.code ==
                            'account-exists-with-different-credential') {
                          Get.showSnackbar(
                            const GetSnackBar(
                              message:
                                  'The account already exists with a different credential',
                              title: "Failed to Sign in with Google",
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (error.code == 'invalid-credential') {
                          Get.showSnackbar(
                            const GetSnackBar(
                              message:
                                  'Error occurred while accessing credentials. Try again.',
                              title: "Failed to Sign in with Google",
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              message: error.message,
                              title: "Failed to Sign in with Google",
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (error) {
                        log(error.toString());
                        Get.showSnackbar(
                          const GetSnackBar(
                            message:
                                'Error occurred using Google Sign In. Try again.',
                            title: "Failed to Sign in with Google",
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    },
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    title: const Center(
                      child: Text(
                        "Log in with Google",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                      ),
                    ),
                    leading: Image.asset(
                      "assets/images/google_logo.png",
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10.0.wp,
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
                            child: SizedBox(width: 3),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                final authController =
                                    Get.put(AuthController());
                                authController.toggleView();
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
      ),
    );
  }
}

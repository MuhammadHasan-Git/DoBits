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

class SignupView extends StatelessWidget {
  final Function toggleView;
  const SignupView({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final user = Get.put(UserController());
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 10),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hey, welcome!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                  SizedBox(
                    height: 1.0.wp,
                  ),
                  Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 16,
                      color: white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthTextField(
                    hintText: "Username",
                    icon: const Icon(Icons.person),
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    validator: (value) {
                      final RegExp nameRegExp =
                          RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      } else if (nameRegExp.hasMatch(value)) {
                        return "Only characters are allowed";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthTextField(
                    hintText: "Email",
                    icon: const Icon(Icons.email),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
                      hintText: "Password",
                      icon: const Icon(Icons.lock),
                      controller: passController,
                      obscureText: authController.isVisibleSignin.value,
                      onchanged: (value) {
                        if (value.isNotEmpty) {
                          authController.isEmptySignin.value = false;
                        } else {
                          authController.isEmptySignin.value = true;
                        }
                      },
                      suffixIcon: authController.isEmptySignin.value
                          ? null
                          : IconButton(
                              splashRadius: 1,
                              icon: Icon(
                                authController.isVisibleSignin.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 25,
                              ),
                              onPressed: () =>
                                  authController.isVisibleSignin.value =
                                      !authController.isVisibleSignin.value,
                            ),
                      validator: (value) {
                        return authController.passValidator(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => AuthTextField(
                      hintText: "Confirm Password",
                      icon: const Icon(Icons.lock),
                      controller: confirmPassController,
                      obscureText: authController.isVisibleSignin1.value,
                      onchanged: (value) {
                        if (value.isNotEmpty) {
                          authController.isEmptySignin1.value = false;
                        } else {
                          authController.isEmptySignin1.value = true;
                        }
                      },
                      suffixIcon: authController.isEmptySignin1.value
                          ? null
                          : IconButton(
                              splashRadius: 1,
                              icon: Icon(
                                authController.isVisibleSignin1.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 25,
                              ),
                              onPressed: () =>
                                  authController.isVisibleSignin1.value =
                                      !authController.isVisibleSignin1.value,
                            ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the password";
                        } else if (value != passController.text) {
                          return 'Password does not match';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                    text: "SignUp",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await user.signUp(nameController, emailController,
                            passController, context);
                      }
                    },
                  ),
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
                      final userController = Get.put(UserController());
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
                        "Continue with Google",
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
                            text: "Already have an account?",
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
                            text: "Login",
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

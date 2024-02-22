import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/controller/user_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/view/authentication/widgets/google_signin.dart';
import 'package:todo_app/view/authentication/widgets/guest_signin.dart';
import 'package:todo_app/view/authentication/widgets/text_field.dart';
import 'package:todo_app/view/widget/button.dart';

class SignupView extends StatelessWidget {
  final Function toggleView;
  const SignupView({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final userController = Get.put(UserController());
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return const MyApp();
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 35, left: 15, right: 15, bottom: 20),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Form(
                      key: _formKey,
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
                          SlideInLeft(
                            duration: const Duration(
                              milliseconds: 350 * 1,
                            ),
                            child: AuthTextField(
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
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SlideInLeft(
                            duration: const Duration(
                              milliseconds: 350 * 2,
                            ),
                            child: AuthTextField(
                              hintText: "Email",
                              icon: const Icon(Icons.email),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              validator: (value) {
                                return authController.emailValidator(value);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => SlideInLeft(
                              duration: const Duration(
                                milliseconds: 350 * 3,
                              ),
                              child: AuthTextField(
                                hintText: "Password",
                                icon: const Icon(Icons.lock),
                                controller: passController,
                                obscureText:
                                    authController.isVisibleSignin.value,
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
                                        onPressed: () => authController
                                                .isVisibleSignin.value =
                                            !authController
                                                .isVisibleSignin.value,
                                      ),
                                validator: (value) {
                                  return authController.passValidator(value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => SlideInLeft(
                              duration: const Duration(
                                milliseconds: 350 * 4,
                              ),
                              child: AuthTextField(
                                hintText: "Confirm Password",
                                icon: const Icon(Icons.lock),
                                controller: confirmPassController,
                                obscureText:
                                    authController.isVisibleSignin1.value,
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
                                        onPressed: () => authController
                                                .isVisibleSignin1.value =
                                            !authController
                                                .isVisibleSignin1.value,
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
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElasticIn(
                            child: CustomButton(
                              text: "SignUp",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await userController.signUp(nameController,
                                      emailController, passController, context);
                                }
                              },
                            ),
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
                          SlideInLeft(child: const GoogleSignInButton()),
                          SizedBox(
                            height: 5.0.wp,
                          ),
                          SlideInRight(child: const GuestSignInButton()),
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
              );
            }
          }),
    );
  }
}

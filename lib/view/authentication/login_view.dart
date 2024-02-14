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

class LoginView extends StatelessWidget {
  final Function? toggleView;
  const LoginView({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final userController = Get.put(UserController());
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: StreamBuilder(
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
              return const MyApp();
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 15, right: 15, bottom: 20),
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
                          const Text(
                            "Signin to your account",
                            style: TextStyle(
                              fontSize: 16,
                              color: grey,
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
                                      onPressed: () => authController
                                              .isVisibleLogin.value =
                                          !authController.isVisibleLogin.value,
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
                              const Expanded(
                                  child: Divider(
                                color: grey,
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
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const GoogleSignInButton(),
                          SizedBox(
                            height: 5.0.wp,
                          ),
                          const GuestSignInButton(),
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
              );
            }
          }),
    );
  }
}

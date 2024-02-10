import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/view/authentication/login_view.dart';
import 'package:todo_app/view/authentication/signup_view.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Obx(
      () => Scaffold(
        body: authController.showSignIn.value
            ? StreamBuilder(
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
                    return LoginView(toggleView: authController.toggleView);
                  }
                },
              )
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const MyApp();
                  } else {
                    return SignupView(toggleView: authController.toggleView);
                  }
                },
              ),
      ),
    );
  }
}

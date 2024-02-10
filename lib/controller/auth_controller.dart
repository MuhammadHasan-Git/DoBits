import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/main.dart';

class AuthController extends GetxController {
  RxBool showSignIn = true.obs;
  RxBool isEmptyLogin = true.obs;
  RxBool isVisibleLogin = true.obs;
  RxBool isEmptySignin = true.obs;
  RxBool isVisibleSignin = true.obs;
  RxBool isEmptySignin1 = true.obs;
  RxBool isVisibleSignin1 = true.obs;
  void toggleView() {
    showSignIn.value = !showSignIn.value;
  }

  createUser(String userName, String email, String pass) async {
    final userRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await userRef.set({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "Name": userName,
      "Email": email,
      "password": pass,
      'createdOn': FieldValue.serverTimestamp(),
    });
  }

  Future signIn(TextEditingController emailController,
      TextEditingController passwordController, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.message,
          title: "Failed to Login",
          duration: const Duration(seconds: 2),
        ),
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signUp(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      createUser(nameController.text.trim(), emailController.text.trim(),
          passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.message,
          title: "Failed to SignUp",
          duration: const Duration(seconds: 2),
        ),
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  String? emailValidator(email) {
    if (email == null || email.isEmpty) {
      return "Please enter an email address";
    } else if (!EmailValidator.validate(email!)) {
      return "Please enter valid email address";
    } else {
      return null;
    }
  }

  String? passValidator(String? password) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
    if (password == null || password.isEmpty) {
      return "Please enter the password";
    } else if (!regex.hasMatch(password)) {
      return 'Enter valid password';
    } else if (password.removeAllWhitespace.length < 8) {
      return 'The password must be 8 char long';
    } else {
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/main.dart';

class UserController extends GetxController {
  void createUser(String userName, String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection("Users").doc(auth.currentUser!.uid);
    await userRef.set({
      "userId": auth.currentUser!.uid,
      "Name": userName,
      "Email": email,
      "password": pass,
      'createdOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signUp(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await auth.createUserWithEmailAndPassword(
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

  Future<void> signIn(TextEditingController emailController,
      TextEditingController passwordController, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await auth.signInWithEmailAndPassword(
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

  Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();

    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredentail =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredentail.user;
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/main.dart';

class UserController extends GetxController {
  Future<DateTime?> getAccountCreationTime() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DateTime? creationTime;
    User? user = auth.currentUser;

    if (user != null) {
      await user.reload();
      user = auth.currentUser;

      if (user != null && user.metadata.creationTime != null) {
        creationTime = user.metadata.creationTime!;
      } else {
        log('User metadata not available.');
      }
      return creationTime;
    } else {
      log('User not signed in.');
    }
    return null;
  }

  void updateSigninTime() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection("Users").doc(auth.currentUser!.uid);
    userRef.update({
      'lastSignin': FieldValue.serverTimestamp(),
    });
  }

  void createUser(String userName, String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection("Users").doc(auth.currentUser!.uid);
    await userRef.set({
      "userId": auth.currentUser!.uid,
      "Name": userName,
      "Email": email,
      'createdOn': await getAccountCreationTime(),
      'lastSignin': FieldValue.serverTimestamp(),
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
      createUser(nameController.text.trim(), emailController.text.trim());
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      updateSigninTime();
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

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
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

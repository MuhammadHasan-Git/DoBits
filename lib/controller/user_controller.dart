import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class UserController extends GetxController {
   Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }

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

  void createGuest() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String? id = await getId();
    final userRef = firestore.collection("Guest").doc(id);
    await userRef.set(
      {
        "userId": id,
        'createdOn': FieldValue.serverTimestamp(),
      },
    );
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

  Future<void> signInAnon(BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: darkBlue,
                  ),
                  SizedBox(
                    height: 3.0.wp,
                  ),
                  const Text(
                    "Logging in...",
                    style: TextStyle(color: blue),
                  )
                ],
              ));
      final auth = FirebaseAuth.instance;
      await auth.signInAnonymously();
      createGuest();
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.message,
          title: "Failed to Login as Guest",
          duration: const Duration(seconds: 2),
        ),
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> signIn(TextEditingController emailController,
      TextEditingController passwordController, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: darkBlue,
                  ),
                  SizedBox(
                    height: 3.0.wp,
                  ),
                  const Text(
                    "Logging in...",
                    style: TextStyle(color: blue),
                  )
                ],
              ));
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

  Future loginWithGoogle(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: darkBlue,
                ),
                SizedBox(
                  height: 3.0.wp,
                ),
                const Text(
                  "Processing...",
                  style: TextStyle(color: blue),
                )
              ],
            ));
    try {
      final googleAccount = await GoogleSignIn().signIn();
      final googleAuth = await googleAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredentail =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredentail.user;
      if (user != null) {
        createUser(user.displayName!, user.email!);
      }
    } on FirebaseAuthException catch (error) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      if (error.code == 'account-exists-with-different-credential') {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'The account already exists with a different credential',
            title: "Failed to Sign in with Google",
            duration: Duration(seconds: 2),
          ),
        );
      } else if (error.code == 'invalid-credential') {
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Error occurred while accessing credentials. Try again.',
            title: "Failed to Sign in with Google",
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Get.showSnackbar(
          GetSnackBar(
            message: error.message,
            title: "Failed to Sign in with Google",
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      log(error.toString());
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

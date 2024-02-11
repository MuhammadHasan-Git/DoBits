import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

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

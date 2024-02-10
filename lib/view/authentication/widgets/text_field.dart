import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final bool obscureText;

  final IconButton? suffixIcon;

  final Function(String)? onchanged;

  final String? Function(String? value) validator;

  final TextInputType? keyboardType;
  const AuthTextField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.obscureText,
      this.suffixIcon,
      this.onchanged,
      required this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onchanged,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w400, color: white),
      cursorColor: Colors.blueAccent,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        prefixIconColor: white.withOpacity(0.5),
        filled: true,
        fillColor: white.withOpacity(0.1),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(style: BorderStyle.none, width: 0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: blue),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: white.withOpacity(0.5),
        ),
      ),
    );
  }
}

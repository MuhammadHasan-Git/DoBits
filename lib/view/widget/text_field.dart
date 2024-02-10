import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.width,
    required this.controller,
    this.hintText,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.color = white,
  });

  final String? hintText;

  final double width;

  final Color? color;

  final bool? readOnly;

  final Function()? onTap;

  final TextAlign? textAlign;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: textAlign!,
        readOnly: readOnly!,
        controller: controller,
        style: TextStyle(
          color: color,
          height: 1.28,
          fontSize: 18,
        ),
        cursorColor: blue,
        onTap: onTap,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: white.withOpacity(0.5)),
          fillColor: white.withOpacity(0.1),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: blue),
          ),
        ),
      ),
    );
  }
}

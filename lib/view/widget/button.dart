import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Function() onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: const MaterialStatePropertyAll(darkBlue),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: white, fontSize: 18),
        ),
      ),
    );
  }
}

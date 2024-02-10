import 'package:flutter/material.dart';

Widget getFooter(text, {optionaltext, onTap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            optionaltext!,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.cyan,
            ),
          ),
        ),
      ],
    ),
  );
}

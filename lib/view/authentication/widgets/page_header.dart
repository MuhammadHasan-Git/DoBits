import 'package:flutter/material.dart';

Widget pageHeader(text, {onPressed}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 40, left: 15, bottom: 40),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            splashRadius: 15,
            splashColor: Colors.grey.withOpacity(0.5),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.blueAccent,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
      Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

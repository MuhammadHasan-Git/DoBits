import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Color Picker')),
      body: ColorPicker(),
    ),
  ));
}

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.black,
  ];
  Color selectedColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ToggleButtons(
          isSelected: isSelected,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                isSelected[buttonIndex] = (buttonIndex == index);
              }
              selectedColor = colors[index];
            });
          },
          children: List.generate(
            colors.length,
            (index) => Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

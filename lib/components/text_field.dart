import 'package:flutter/material.dart';

TextEditingController controller = TextEditingController();

Widget textField(String hintText, TextEditingController controller) {
  return TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.purple[50],
      hintText: hintText,
    ),
    keyboardType: TextInputType.number,
    controller: controller,
  );
}

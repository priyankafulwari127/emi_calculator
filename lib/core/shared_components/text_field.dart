import 'package:flutter/material.dart';

TextEditingController controller = TextEditingController();

Widget textField(BuildContext context, String hintText, TextEditingController controller) {
  return SizedBox(
    height: 50,
    width: MediaQuery.sizeOf(context).width,
    child: TextField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium
      ),
      keyboardType: TextInputType.number,
      controller: controller,
    ),
  );
}

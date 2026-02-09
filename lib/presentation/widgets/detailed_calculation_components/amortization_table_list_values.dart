import 'package:flutter/cupertino.dart';

Widget amortizationTableListValues(String title){
  return Expanded(
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
      ),
    ),
  );
}
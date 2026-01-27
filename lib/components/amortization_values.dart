import 'package:flutter/cupertino.dart';

Widget amortizationValues(String title){
  return Expanded(
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailedCalculation extends StatelessWidget {
  final int tab;

  const DetailedCalculation({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Calculation'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [Text('Principle Amount')],
        ),
      ),
    );
  }
}

import 'package:emi_calculator/bloc/emi_bloc.dart';
import 'package:emi_calculator/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Using Bloc state management in this project
// Bloc state management flow
// UI -> Triggers Event -> Sends to Bloc -> Updates State -> UI
// in my app
// calculate button click -> calculateEmi() in event -> bloc receives EMI, sends to State -> EmiCalculated() -> changes UI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return EmiBloc();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

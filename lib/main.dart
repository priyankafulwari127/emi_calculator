import 'package:emi_calculator/bloc_state_management/bloc/interest_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/loan_amount_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/period_bloc.dart';
import 'package:emi_calculator/bloc_state_management/cubit/pre_payment_visibility.dart';
import 'package:emi_calculator/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_state_management/bloc/emi_bloc.dart';
import 'bloc_state_management/cubit/list_visibility_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmiBloc()),
        BlocProvider(create: (_) => LoanAmountBloc()),
        BlocProvider(create: (_) => InterestBloc()),
        BlocProvider(create: (_) => PeriodBloc()),
        BlocProvider(create: (_) => ListVisibilityCubit()),
        BlocProvider(create: (_) => PrePaymentVisibility()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

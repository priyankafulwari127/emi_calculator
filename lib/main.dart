import 'package:emi_calculator/data/repository/auth_repository.dart';
import 'package:emi_calculator/domain/wrapper/auth_wrapper.dart';
import 'package:emi_calculator/firebase_options.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:emi_calculator/presentation/bloc/home_bloc/emi/emi_bloc.dart';
import 'package:emi_calculator/presentation/bloc/home_bloc/interest/interest_bloc.dart';
import 'package:emi_calculator/presentation/bloc/home_bloc/loan_amount/loan_amount_bloc.dart';
import 'package:emi_calculator/presentation/bloc/home_bloc/period/period_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/shared_cubit/list_visibility_cubit.dart';
import 'core/shared_cubit/pre_payment_visibility.dart';

// Using Bloc state management in this project
// Bloc state management flow
// UI -> Triggers Event -> Sends to Bloc -> Updates State -> UI
// in my app
// calculate button click -> calculateEmi() in event -> bloc receives EMI, sends to State -> EmiCalculated() -> changes UI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository())..add(AppStarted()),
        ),
        BlocProvider(create: (_) => EmiBloc()),
        BlocProvider(create: (_) => LoanAmountBloc()),
        BlocProvider(create: (_) => InterestBloc()),
        BlocProvider(create: (_) => PeriodBloc()),
        BlocProvider(create: (_) => ListVisibilityCubit()),
        BlocProvider(create: (_) => PrePaymentVisibility()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

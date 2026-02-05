import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:emi_calculator/presentation/screens/auth/login_screen.dart';
import 'package:emi_calculator/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is Authenticated) {
          return HomeScreen();
        }

        return LoginScreen();
      },
    );
  }
}

import 'package:emi_calculator/core/shared_components/text_field.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  static String? _verificationId;
  static bool otpSent = false;

  void sendOtp(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
      },
      codeSent: (id, _) {
        _verificationId = id;
        otpSent = true;
        (context as Element).markNeedsBuild();
      },
      codeAutoRetrievalTimeout: (id) {
        _verificationId = id;
      },
    );
  }

  void verifyOtp(BuildContext context) {
    context.read<AuthBloc>().add(
          VerifyOtp(_verificationId!, smsCodeController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.purple[400],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.purple[50],
                  hintText: 'Enter phone-number',
                ),
                keyboardType: TextInputType.text,
                controller: phoneNumberController,
              ),
              const SizedBox(
                height: 10,
              ),
              textField('Enter one-time passcode', smsCodeController),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    otpSent ? verifyOtp(context) : sendOtp(context);
                  },
                  child: Text(
                    otpSent ? "Verify OTP" : "Send OTP",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

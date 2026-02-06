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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Error")),
        );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            //   title: Text(
            //     'Login',
            //     style: Theme.of(context).textTheme.displaySmall,
            //     selectionColor: Theme.of(context).colorScheme.onPrimary,
            //   ),
            //   // backgroundColor: Theme.of(context).colorScheme.primary,
            //   centerTitle: true,
            ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'What is your phone number?',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
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
                    hintText: 'Enter phone-number',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                  keyboardType: TextInputType.text,
                  controller: phoneNumberController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              textField(
                context,
                'Enter one-time passcode',
                smsCodeController,
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    otpSent ? verifyOtp(context) : sendOtp(context);
                  },
                  child: Text(
                    otpSent ? "Verify OTP" : "Send OTP",
                    style: Theme.of(context).textTheme.bodyMedium,
                    selectionColor: Theme.of(context).colorScheme.onPrimary,
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

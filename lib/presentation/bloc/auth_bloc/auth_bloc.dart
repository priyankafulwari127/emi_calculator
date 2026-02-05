import 'dart:async';

import 'package:emi_calculator/data/repository/auth_repository.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription<User?>? streamSubscription;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    //when app starts
    on<AppStarted>((event, emit) {
      emit(AuthLoading());
      var user = authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    });

    //verify otp
    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        final credentials = await authRepository.verifyOtp(
          verificationId: event.verificationId,
          smsCode: event.smsCode,
        );
        emit(Authenticated(credentials.user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    //logout
    on<LogoutRequest>((event, emit) async {
      authRepository.signOut();
      emit(UnAuthenticated());
    });
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}

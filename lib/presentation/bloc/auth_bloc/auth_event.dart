abstract class AuthEvent {}

class AppStarted extends AuthEvent{}

class SendOtp extends AuthEvent{
  final String phoneNumber;
  SendOtp(this.phoneNumber);
}

class VerifyOtp extends AuthEvent{
  final String verificationId;
  final String smsCode;
  VerifyOtp(this.verificationId, this.smsCode);
}

class LogoutRequest extends AuthEvent{}
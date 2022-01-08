part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class UnAuthenticated extends AuthState {}

class AuthChecking extends AuthState {}

class SameScreenChecking extends AuthState {}

class Authenticated extends AuthState {
  final User? user;
  Authenticated({this.user});
}

class OTPVerification extends AuthState {
  final User? user;
  OTPVerification({this.user});
}

class ResettingPassword extends AuthState {
  final User? user;
  ResettingPassword({this.user});
}

class ProfileUncompleted extends AuthState {
  final User? user;
  ProfileUncompleted({this.user});
}

class AuthFail extends AuthState {
  final String message;
  AuthFail(this.message);
}

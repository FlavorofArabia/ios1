part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckAuth extends AuthEvent {}

class Login extends AuthEvent {
  final Map<String, String> form;
  Login(this.form);
}

class SignUp extends AuthEvent {
  final Map<String, dynamic> form;
  SignUp(this.form);
}

class GetSession extends AuthEvent {}

class GetAccountInfo extends AuthEvent {}

class Logout extends AuthEvent {}

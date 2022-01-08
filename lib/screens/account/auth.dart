import './register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool register = false;

  toRegister() {
    setState(() {
      register = true;
    });
  }

  toLogin() {
    setState(() {
      register = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return register ? RegisterScreen(toLogin) : LoginScreen(toRegister);
  }
}

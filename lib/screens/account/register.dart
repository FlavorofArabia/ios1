import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../components/primary_button.dart';
import '../../components/secodary_button.dart';
import '../../config/images.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback goToLogin;
  RegisterScreen(this.goToLogin);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Map<String, dynamic> _registerForm = {
    'name': '',
    'email': '',
    'telephone': '',
    'password': '',
    'confirm': '',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              // child: Form(
              //   key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'تسجيل جديد',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 100,
                    child: Image.asset(
                      Images.Logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'مرحبا بك',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'يرجي التسجيل لاكمال تسوقك',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Material(
                    shadowColor: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'الاسم',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (String value) {
                        _registerForm['name'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    shadowColor: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'البريد الالكتروني',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (String value) {
                        _registerForm['email'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    shadowColor: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'رقم الجوال',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (String value) {
                        _registerForm['telephone'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    shadowColor: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'كلمة المرور',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (String value) {
                        _registerForm['password'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    shadowColor: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'تأكيد كلمة المرور',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (String value) {
                        _registerForm['confirm'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFail) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state is SameScreenChecking) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          PrimaryButton(
                              padding: 12,
                              height: 35,
                              textSize: 16,
                              textWeight: FontWeight.bold,
                              title: "التسجيل",
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(SignUp(_registerForm));
                              }),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لديك حساب ؟ ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: widget.goToLogin,
                                child: Text(
                                  'سجل الدخول الان',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                ],
              ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback goToRegister;
  LoginScreen(this.goToRegister);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Map<String, String> _loginForm = {
    'email': '',
    'password': '',
  };

  String email = '';

  String password = '';

  Widget _buildEmailField() {
    return Material(
      shadowColor: Color(0xffF6F6F6),
      borderRadius: BorderRadius.circular(8),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelText: 'البريد الالكتروني',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) {
          _loginForm['email'] = value;
          email = value;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Material(
      shadowColor: Color(0xffF6F6F6),
      borderRadius: BorderRadius.circular(8),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelText: 'كلمة المرور',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) {
          _loginForm['password'] = value;
          password = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 100,
                    child: Image.asset(
                      Images.Logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'مرحبا بك',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'يرجي تسجيل الدخول لاكمال تسوقك',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildEmailField(),
                  SizedBox(height: 10),
                  _buildPasswordField(),
                  SizedBox(height: 10),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFail) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state is SameScreenChecking) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          PrimaryButton(
                            padding: 12,
                            height: 35,
                            textSize: 16,
                            textWeight: FontWeight.bold,
                            title: "تسجيل الدخول",
                            onTap: () => BlocProvider.of<AuthBloc>(context).add(
                              Login({
                                'email': email,
                                'password': password,
                              }),
                              // Login(_loginForm),
                            ),
                          ),
                          SizedBox(height: 8),
                          SecondaryButton(
                            verticalPadding: 10,
                            horizontalPadding: 5,
                            textSize: 16,
                            title: "تسجيل جديد",
                            onTap: widget.goToRegister,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

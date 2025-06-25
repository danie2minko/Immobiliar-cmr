import 'package:flutter/material.dart';
import 'package:immobiliakamer/pages/registerPage.dart';
import 'package:immobiliakamer/pages/login.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin= true;

void toggleScreen() {
  setState(() {
    showLogin = !showLogin;
  });
}

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
     return Login(showRegisterPage: toggleScreen);
    }else{return Registerpage(showLogin: toggleScreen);}
  }
}
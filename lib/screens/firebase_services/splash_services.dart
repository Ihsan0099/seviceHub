import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihsantech/screens/home/home_screen.dart';
import 'package:ihsantech/screens/ui/auth/login_screen.dart';



class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 4),
              () =>
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 4),
              () =>
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen())));
    }
  }
}

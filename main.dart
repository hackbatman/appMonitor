import 'dart:async';
import 'package:app_mntr_bt/views/home.dart';
import 'package:app_mntr_bt/views/login.dart';
import 'package:flutter/material.dart';
import 'database/share_reference.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const int maxLoadingTime = 20;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
//    _startTimeout();
    _checkLoginState();
  }

  void _startTimeout() {
    _timer = Timer(const Duration(seconds: maxLoadingTime), () {
      _redirectToLogin();
    });
  }

  void _checkLoginState() async {
    bool isLoggedIn = await SessionManager.isLoggedIn();

    // _timer?.cancel();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home_Monitor()),
      );
    } else {
      //  _redirectToLogin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

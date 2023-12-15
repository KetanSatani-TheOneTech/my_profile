import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_profile_ketan/pages/login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();



    Timer(const Duration(seconds: 3),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage('assets/images/app_logo.png')),
      ),
    );
  }
}

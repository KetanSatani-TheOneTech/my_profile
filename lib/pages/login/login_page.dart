import 'package:flutter/material.dart';
import 'package:my_profile_ketan/pages/login/widgets/login_form_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(18),
        child: LoginFormWidget(),
      ),
    );
  }
}

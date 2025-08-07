import 'package:daily_planner/core/utils/common_widgets.dart';
import 'package:daily_planner/features/widgets/login_widget.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CommonAppbar(title: "Log in"),
            LoginWidget(),
          ],
        ),
      ),
    );
  }
}

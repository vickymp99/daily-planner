import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/widgets/signin_widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Column(
      children: [
        CommonAppbar(title: "Sign In"),
         SignInWidget(),
      ],
    )));
  }
}

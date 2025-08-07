import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_widgets.dart';
import 'package:daily_planner/features/pages/home.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _UserNameAndPassword(),
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Forgot Password",
                style: DailyPlannerStyle.normalText(fontSize: 14),
              ),
            ),
          ),
          SizedBox(height: 48.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Home()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade200,
              ),
              child: Text("Log in", style: DailyPlannerStyle.buttonText()),
            ),
          ),
          SizedBox(height: 24.0),
          _SignIn(),
        ],
      ),
    );
  }
}

class _UserNameAndPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("User Name", style: DailyPlannerStyle.fieldLabelText()),
          SizedBox(height: 6.0),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: "Username",
              hintStyle: DailyPlannerStyle.hintText(),
            ),
          ),
          SizedBox(height: 48.0),
          Text("Password", style: DailyPlannerStyle.fieldLabelText()),
          SizedBox(height: 6.0),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "Password",
              hintStyle: DailyPlannerStyle.hintText(),
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have account"),
            TextButton(onPressed: () {}, child: Text("Sign in")),
          ],
        ),
        Text("Or Sign in Using"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset("")
          ],
        ),
      ],
    );
  }
}

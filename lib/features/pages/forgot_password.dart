import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonAppbar(title: "Forgot Password"),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Enter your Email id, So that we will send a link to change ypur password",
              style: DailyPlannerStyle.fieldLabelText(),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              maxLength: 50,
              decoration: InputDecoration(
                counterText: "",
                hintText: "Email id",
                hintStyle: DailyPlannerStyle.hintText(),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CommonElevatedButton(
              onPressed: () {
                BlocProvider.of<LoginCubit>(
                  context,
                ).forgotPassword(controller.text);
                Navigator.pop(context);
              },
              text: "Send link",
            ),
          ),
        ],
      ),
    );
  }
}

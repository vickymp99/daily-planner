import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/cubit/login_cubit.dart';
import 'package:daily_planner/features/pages/forgot_password.dart';
import 'package:daily_planner/features/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [_UserNameAndPassword(), SizedBox(height: 24.0), _SignIn()],
      ),
    );
  }
}

class _UserNameAndPassword extends StatelessWidget {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          CommonUtils.snackBar(context, msg: state.msg);
        } else if (state is LoginSuccessState) {
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const Home()),
          //   (Route<dynamic> route) =>
          //       false, // false = remove all previous routes
          // );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User Name", style: DailyPlannerStyle.fieldLabelText()),
            SizedBox(height: 6.0),
            TextField(
              controller: _userNameController,
              maxLength: 50,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                counterText: "",
                hintText: "Username",
                hintStyle: DailyPlannerStyle.hintText(),
              ),
            ),
            const SizedBox(height: 32.0),
            Text("Password", style: DailyPlannerStyle.fieldLabelText()),
            const SizedBox(height: 6.0),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return TextField(
                  controller: _passwordController,
                  maxLength: 20,
                  obscureText: !loginCubit.isVisibility,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    counterText: "",
                    hintStyle: DailyPlannerStyle.hintText(),
                    suffixIcon: InkWell(
                      onTap: () =>
                          loginCubit.changeVisibility(!loginCubit.isVisibility),
                      child: loginCubit.isVisibility
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password",
                  style: DailyPlannerStyle.normalText(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 48.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<LoginCubit>(context).loginUser(
                    _userNameController.text,
                    _passwordController.text,
                  );
                },
                child: Text("Log in", style: DailyPlannerStyle.buttonText()),
              ),
            ),
          ],
        ),
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
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SignIn())),
              child: Text("Sign in"),
            ),
          ],
        ),
        // Text("Or Sign in Using"),
        // SizedBox(height: 12),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(
        //       width: 30,
        //       height: 30,
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(48),
        //         child: Image.asset("assets/images/google.png"),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

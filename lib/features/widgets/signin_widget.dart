import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/cubit/Signin_cubit.dart';
import 'package:daily_planner/features/cubit/login_cubit.dart';
import 'package:daily_planner/features/usecase/login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWidget extends StatelessWidget {
  SignInWidget({super.key});

  String _name = "";
  String _password = "";
  String _gmail = "";
  String _dob = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInErrorState) {
          CommonUtils.snackBar(context, msg: state.msg);
        }
        else if(state is SignInSuccessState){
          Navigator.pop(context);
        }
      },
      listenWhen: (pre, cur) {
        return cur is SignInErrorState || cur is SignInSuccessState;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              hintText: "Your name",
              onChanged: (value) {
                _name = value;
              },
            ),
            SizedBox(height: 16.0),
            CommonTextField(
              hintText: "DOB",
              type: TextFieldActionType.date,
              enable: false,
              onTap: (value) {
                _dob = value;
              },
            ),
            SizedBox(height: 16.0),
            CommonTextField(
              hintText: "Your email",
              onChanged: (value) {
                _gmail = value;
              },
            ),
            SizedBox(height: 16.0),
            CommonTextField(
              hintText: "Password",
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(height: 16.0),
            CommonElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<SignInCubit>(context).signInUser(
                  UserDetailsModel(
                    name: _name,
                    email: _gmail,
                    dob: _dob,
                    password: _password,
                  ),
                );
              } ,
              text: "Sign In",
            ),
          ],
        ),
      ),
    );
  }
}

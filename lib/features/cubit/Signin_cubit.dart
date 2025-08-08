import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/features/usecase/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitialState());

  // Sign in User
  signInUser(UserDetailsModel userDetail) async {
    String formatUserName = userDetail.email.trim();
    String formatPassword = userDetail.password.trim();

    if (_checkCredential(userDetail)) {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: formatUserName,
        password: formatPassword,
      );
      if (result is UserCredential) {
        await FirebaseFirestore.instance.collection("user-details").add({
          'name': userDetail.name,
          'email': userDetail.email,
          'dob': userDetail.dob,
          'id': result.user!.uid,
        });
        emitState(SignInSuccessState());
      } else {
        emit(SignInErrorState(msg: result.toString()));
      }
      // emitState(SignInSuccessState());
    } else {
      emitState(SignInErrorState(msg: "Enter details correctly"));
    }
  }

  bool _checkCredential(UserDetailsModel userDetail) {
    return userDetail.email.isNotEmpty &&
            userDetail.email.contains("@") &&
            userDetail.password.isNotEmpty &&
            userDetail.password.length >= 6 &&
            userDetail.dob.isNotEmpty &&
            userDetail.name.isNotEmpty
        ? true
        : false;
  }

  emitState(SignInState state) {
    emit(state);
    emit(_SignInChangeState());
  }
}

abstract class SignInState extends Equatable {}

class SignInInitialState extends SignInState {
  @override
  List<Object?> get props => [];
}

class _SignInChangeState extends SignInState {
  @override
  List<Object?> get props => [];
}

// Sign in state
class SignInLoadingState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInSuccessState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInErrorState extends SignInState {
  final String msg;
  SignInErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

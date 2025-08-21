import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/core/utils/data_repository.dart';
import 'package:daily_planner/core/utils/firebase_service.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
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
        await FirebaseFirestore.instance
            .collection("user-details")
            .add({
              'name': userDetail.name,
              'email': userDetail.email,
              'dob': userDetail.dob,
              'id': result.user!.uid,
            })
            .then((val) {
              // save user in local storage
              final dataRepository = DataRepository(FirebaseService());
              dataRepository.listenChanges();
              dataRepository.initLoad();
              appDebugPrint("user name ${userDetail.name}");
              HiveService.userDetails.put("userName", userDetail.name);
            });
        emitState(SignInSuccessState());
      } else {
        emit(SignInErrorState(msg: result.toString()));
      }
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

  @override
  void onChange(Change<SignInState> change) {
    super.onChange(change);
    appDebugPrint("Change $change");
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

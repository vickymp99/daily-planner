import 'package:daily_planner/core/utils/data_repository.dart';
import 'package:daily_planner/core/utils/firebase_service.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  // Login User
  loginUser(String userName, String password) async {
    String formatUserName = userName.trim();
    String formatPassword = password.trim();

    if (_checkCredential(formatUserName, formatPassword)) {
      try {
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: formatUserName,
              password: formatPassword,
            )
            .then((val) {
              appDebugPrint("Calls");
              final dataRepository = DataRepository(FirebaseService());
              dataRepository.listenChanges();
              dataRepository.initLoad();
            });

        // if (user is UserCredential) {
        //   emit(LoginSuccessState());
        // } else {
        //   emitState(LoginErrorState(msg: user.toString()));
        // }
      } catch (e) {
        emitState(LoginErrorState(msg: e.toString()));
      }
    } else {
      emitState(LoginErrorState(msg: "Enter correct userName / Password"));
    }
  }

  // Sign in User
  signInUser(String userName, String password) {
    String formatUserName = userName.trim();
    String formatPassword = password.trim();
  }

  bool _checkCredential(String name, String password) {
    return name.isNotEmpty &&
            name.contains("@") &&
            password.isNotEmpty &&
            password.length >= 6
        ? true
        : false;
  }

  emitState(LoginState state) {
    emit(state);
    emit(_LoginChangeState());
  }
}

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class _LoginChangeState extends LoginState {
  @override
  List<Object?> get props => [];
}

// Log in state
class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginBuildState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginErrorState extends LoginState {
  final String msg;
  LoginErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

import 'package:daily_planner/core/utils/data_repository.dart';
import 'package:daily_planner/core/utils/firebase_service.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  bool _isVisibility = false;
  bool get visibility => _isVisibility;

  // Login User
  loginUser(String userName, String password) async {
    String formatUserName = userName.trim();
    String formatPassword = password.trim();

    if (_checkCredential(formatUserName, formatPassword)) {
      try {
        await FirebaseAuth.instance
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
      } catch (e) {
        emitState(LoginErrorState(msg: e.toString()));
      }
    } else {
      emitState(LoginErrorState(msg: "Enter correct userName / Password"));
    }
  }

  // checkCredential
  bool _checkCredential(String name, String password) {
    return name.isNotEmpty &&
            name.contains("@") &&
            password.isNotEmpty &&
            password.length >= 6
        ? true
        : false;
  }

  // changeVisibility
  changeVisibility(bool value) {
    _isVisibility = value;
    emitState(LoginBuildState());
  }

  // send password reset link to email using forgot password
  forgotPassword(String email) async {
    if (!email.contains("@")) return;
    final String formatEmail = email.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: formatEmail);
      emitState(
        LoginErrorState(msg: "Password reset email sent to $formatEmail"),
      );
    } on FirebaseAuthException catch (e) {
      emitState(LoginErrorState(msg: "Error: ${e.message}"));
    }
  }

  // emit the state based on the current state
  emitState(LoginState state) {
    if (state is _LoginChangeState) {
      emit(state);
    } else {
      emit(_LoginChangeState());
      emit(state);
    }
  }

  // Login using google account
  Future<User?> loginWithGoogle() async {
    var result = await FirebaseService.signInWithGoogle();
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

// Log build in state
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

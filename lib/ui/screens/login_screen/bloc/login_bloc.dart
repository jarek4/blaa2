import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';

part 'login_state.dart';

/*
Login process:
Version 1.0.0
- verify if email and password are not empty,
- authentication repository signIn() calls the user repository getUserWithEmailAndPassword()
- user repository checks in sqflite DB if there is any user with given credentials
- if DB has the user hasCreatedUser() returns the id or null
- authentication repository saves email and password in secured storage
- authentication repository emits status: AuthStatus.authenticated to witch
  authentication BLoC reacts.
 */

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepoI authenticationRepository,
  })  : _aRepo = authenticationRepository,
        super(const LoginState()) {
    on<SignInFormSubmitted>(_onSignInSubmitted);
    on<ForgotPassword>(_onForgotPassword);
    on<LoginError>(_onLoginError);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
  }

  // authenticationRepository.signIn() returns current user id or null
  final AuthRepoI _aRepo;
  static const String _emptyFieldsMsg = 'Please enter email and password';

  void _onSignInSubmitted(
    SignInFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {

    // check if email and password are not empty and add status: isValidated or not
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      emit(state.copyWith(status: LoginStatus.isValidated, errorMsg: null));
    } else {
      emit(state.copyWith(
          status: LoginStatus.failure,
          errorMsg: _emptyFieldsMsg,
          password: ''));
    }
    if (state.status == LoginStatus.isValidated) {
      emit(state.copyWith(status: LoginStatus.loading, errorMsg: null));
      try {
        int? _userId = await _aRepo.signIn(
          email: state.email,
          password: state.password,
        );
        if(_userId != null) {
          emit(state.copyWith(status: LoginStatus.success, errorMsg: null));
        } else {
          emit(state.copyWith(
              status: LoginStatus.failure, errorMsg: 'Wrong credentials', password: ''));
        }
      } catch (e) {
        emit(state.copyWith(
            status: LoginStatus.failure, errorMsg: e.toString()));
      }
    }
  }

  void _onForgotPassword(
    ForgotPassword event,
    Emitter<LoginState> emit,
  ) {
    final String input = event.email;
    final int emailCharacters = input.characters.length;
    final String errorMsg = emailCharacters < 6 ? 'invalid' : 'notReady';
    emit(state.copyWith(status: LoginStatus.loading, errorMsg: null));
    try {
       emit(state.copyWith(status: LoginStatus.forgotPass, email: event.email, errorMsg: errorMsg));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMsg: e.toString()));
    }
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final String? _e = event.email;

    emit(state.copyWith(email: _e));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final String? _p = event.password;
    // check if password is valid and add status: valid or not ?
    emit(state.copyWith(password: _p));
  }

  void _onLoginError(
    LoginError event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(status: LoginStatus.failure, errorMsg: event.msg));
  }
}

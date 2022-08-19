import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_state.dart';

/*
Registration process:
Version 1.0.0
- verify if email and password are valid,
- authentication repository signUp() calls the user repository createUser()
- user repository saves user data in sqflite local database (db gives the new user id)
- authentication repository saves email and password in secured storage
- authentication repository emits status: AuthStatus.authenticated to witch
  authentication BLoC reacts.
- authentication BLoC calls user repository get user

 */

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({required this.authenticationRepository})
      : super(const RegistrationState());

  final AuthRepoI<AuthStatus> authenticationRepository;

  void onUsernameChanged(String value) {
    print(value);
    emit(state.copyWith(
        username: value, formStatus: FormSubmissionStatus.initial));
  }

  void onEmailChanged(String value) {
    print(value);
    emit(
        state.copyWith(email: value, formStatus: FormSubmissionStatus.initial));
  }

  void onPasswordChanged(String value) {
    print(value);
    emit(state.copyWith(
        password: value, formStatus: FormSubmissionStatus.initial));
  }

  void onLangToLearnChanged(String value) {
    emit(state.copyWith(
        langToLearn: value, formStatus: FormSubmissionStatus.initial));
  }

  void onNativeLangChanged(String value) {
    emit(state.copyWith(
        nativeLang: value, formStatus: FormSubmissionStatus.initial));
  }

  void onFormSubmit() async {
    emit(state.copyWith(formStatus: FormSubmissionStatus.submitting));
    //forms fields validation is handled by the form itself

    if (state.isEmailValid &&
        state.isLangToLearnValid &&
        state.isNativeLangValid &&
        state.isPasswordValid &&
        state.isUsernameValid) {
      try {
        // authenticationRepository.signUp returns created user id or null
        int? _id = await authenticationRepository.signUp(
            email: state.email,
            username: state.username,
            password: state.password,
            langToLearn: state.langToLearn,
            nativeLang: state.nativeLang);
        if (_id != null) {
          emit(state.copyWith(
              formStatus: FormSubmissionStatus.success,
              email: '',
              password: ''));
        } else {
          emit(state.copyWith(
            formStatus: FormSubmissionStatus.failed,
            errorMessage:
                'New user was not created. Fill out the entire form properly',
          ));
        }
      } catch (e) {
        // authenticationRepository.signUp throws Exceptions
        print(e);
        emit(state.copyWith(
          formStatus: FormSubmissionStatus.failed,
          errorMessage: e.toString(),
        ));
      }
    } else {
      emit(state.copyWith(
        formStatus: FormSubmissionStatus.failed,
        errorMessage: 'Fill out the entire form properly',
      ));
    }
  }
}

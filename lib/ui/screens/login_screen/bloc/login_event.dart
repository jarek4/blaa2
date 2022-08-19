part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}
class SignInFormSubmitted extends LoginEvent {
  const SignInFormSubmitted();
  @override
  List<Object> get props => [];
}
class ForgotPassword extends LoginEvent {
  const ForgotPassword(this.email);
  final String email;
  @override
  List<Object> get props => [email];
}
class LoginError extends LoginEvent {
  const LoginError(this.msg);
  final String? msg;
  @override
  List<Object?> get props => [msg];
}
class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

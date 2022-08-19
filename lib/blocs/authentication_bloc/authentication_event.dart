part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}
class AuthenticationAtAppStart extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
class AuthenticationDeleteUserDataRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
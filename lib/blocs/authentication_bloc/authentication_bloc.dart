import 'dart:async';
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthRepoI<AuthStatus> aRepo,
    required UserRepoI<User> uRepo,
  })  : _authRepo = aRepo,
        _userRepo = uRepo,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationAtAppStart>(_onAuthenticationAtAppStart);
    _authenticationStatusSubscription = _authRepo.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthRepoI<AuthStatus> _authRepo;
  final UserRepoI<User> _userRepo;
  late StreamSubscription<AuthStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authRepo.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('_onAuthenticationStatusChanged, event: $event');
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthStatus.authenticated:
        final User? user = await _userRepo.user;
        return emit(user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationAtAppStart(
    AuthenticationAtAppStart event,
    Emitter<AuthenticationState> emit,
  ) async {
    // await _cleanIfFirstUseAfterUninstall();
    if (state.status == AuthStatus.authenticated) {
      //AuthenticationState.authenticated(state.user!);
      return;
    } else {
      try {
        await _authRepo.tryToSignInAtStart();
        // If email and token are found in secured storage
        // tryToSignInAtStart() performs _controller.add(AuthStatus.authenticated)
      } catch (e) {
        emit(const AuthenticationState.unknown());
      }
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('_onAuthenticationLogoutRequested, event: $event');
    await _authRepo.signOut();
    emit(const AuthenticationState.unauthenticated());
  }

 /* Future<User?> _tryGetUser(String userEmail) async {
    try {
      final User? user = await _userRepo.user;
      return user;
    } catch (_) {
      return null;
    }
  }*/
// Future<void> _cleanIfFirstUseAfterUninstall() async {
//   final prefs = await SharedPreferences.getInstance();
//
//   if (prefs.getBool('first_run') ?? true) {
//     await userRepository.deleteAll();
//     await prefs.setBool('first_run', false);
//   }
// }
}

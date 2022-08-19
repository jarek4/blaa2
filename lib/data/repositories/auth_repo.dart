// 1) when sign up:
// - calls the user repository createUser();
// - returns int user ID if successful or null;
// - save email and token (at the beginning from password) if user is created
//   in flutter secure storage
// - emits status: AuthStatus.authenticated
// - Then authentication BLoC calls user repository get user.
//
// 2) when sign out:
// remove token from secure storage
//
// 3)
// when sign in://
// - check in DB if here is an user with given @ and pass.
// - if there is -> emits status: AuthStatus.authenticated
// - Then authentication BLoC calls user repository get user.
//
// when app starts:
// - check if in secure storage there is any @ and token and try
// - to sign in with this credentials [ tryToSignIn()  ].

import 'dart:async';
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/providers/storage_secured/storage_secured_interface/storage_secure_interface.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:blaa/locator.dart';

// enum AuthStatus { unknown, authenticated, registered, unauthenticated }

// Authentication Repository (AuthRepo) implements
// Authentication Repository Interface (AuthRepoI<T>) to fulfil Domain's contract
// exposes a Stream of AuthStatus to notify the application when a user signs in or out.

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepo implements AuthRepoI<AuthStatus> {
  AuthRepo(this.userRepository);

  final UserRepoI<User> userRepository;

  final _controller = StreamController<AuthStatus>.broadcast();

  // flutter secure storage object:
  final StorageSecInterface _storage = locator<StorageSecInterface>();

  @override
  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  // login bloc depends on signIn return value!
  @override
  Future<int?> signIn({
    required String email,
    required String password,
  }) async {
    int? _currentUserId;
    // check if in DB there is an user with given credentials
    // if there is it will be returned
    // save email and password in secured storage
    // _controller.add(AuthStatus.authenticated);
    try {
      // if DB has the user loginUserWithEmailPassword() returns the id or null
      _currentUserId =
          await userRepository.loginUserWithEmailPassword(email, password);
      print('Auth repo - signIn: currentUserId: $_currentUserId');
      if (_currentUserId != null) {
        await _storage.persistEmailAndToken(email, password);
        _controller.add(AuthStatus.authenticated);
      } else {
        _controller.add(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _controller.add(AuthStatus.unauthenticated);
      throw Exception('Logging in not finished. Error: ${e.toString()}');
    }
    return _currentUserId;
  }

  // registration Cubit depends on signUp return value!
  @override
  Future<int?> signUp({
    required String email,
    required String username,
    required String password,
    required String langToLearn,
    required String nativeLang,
  }) async {
    User _tempU = const User().copyWith(
      email: email,
      name: username,
      password: password,
      langToLearn: langToLearn,
      nativeLang: nativeLang,
    );
    try {
      // save new user data into local database or Firebase!
      // userRepository.createUser() returns id or null
      int? _res = await userRepository.createUser(_tempU);
      if (_res != null) {
        await _storage.persistEmailAndToken(email, password);
        _controller.add(AuthStatus.authenticated);
        // when state is authenticated, AuthBloc will perform call to
        // userRepo for user detail info.
        return _res;
      } else {
        _controller.add(AuthStatus.unauthenticated);
        return null;
      }
    } catch (e) {
      _controller.add(AuthStatus.unauthenticated);
      throw Exception(
          'Registration process not finished. Error: ${e.toString()}');
    }
  }

  @override
  Future<void>  signOut() async {
    await _storage.deleteAll();
    _controller.add(AuthStatus.unauthenticated);
  }

  // when app starts check if there is the signed in user:
  // if is, there will are email and token in secured storage
  @override
  Future<void> tryToSignInAtStart() async {
    try {
      String? _tk = await _storage.getToken();
      String? _em = await _storage.getEmail();
      if (_em != null && _tk != null) {
        await userRepository.getUser(_em.toString());
        _controller.add(AuthStatus.authenticated);
      } else {
        // in secure storage there is no token or email
        // can not login
        print('Can not sign in');
        _controller.add(AuthStatus.unauthenticated);
      }
    } catch (_) {
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  @override
  void dispose() => _controller.close();
}

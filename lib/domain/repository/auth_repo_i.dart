import 'dart:async';

//enum AuthStatus { unknown, authenticated, registered, unauthenticated }

abstract class AuthRepoI<T> {
  // final _controller = StreamController<T>();

  // returns current user id or null
  Future<int?> signIn({required String email, required String password});

// returns created user id or null
  Future<int?> signUp(
      {required String email,
      required String username,
      required String password,
      required String langToLearn,
      required String nativeLang});

  Future<void> tryToSignInAtStart();

  Future<void>  signOut();

  Stream<T> get status;

  void dispose();
}

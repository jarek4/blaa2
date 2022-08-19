// ignore_for_file: prefer_const_constructors

import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/providers/storage_secured/storage_secured_interface/storage_secure_interface.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockUserRepoI extends Mock implements UserRepoI<User> {}

class MockSecureStorage extends Mock implements StorageSecInterface {}

void main() {
  const _user = User();
  late AuthRepo _aR;
  late UserRepoI<User> _uR;
  setUp(() {
    _aR = MockAuthRepo();
    when(() => _aR.status).thenAnswer((_) => const Stream.empty());
    _uR = MockUserRepoI();
  });

  group('AuthenticationBloc emits', () {
    test('initial state == AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      );
      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });
    blocTest<AuthenticationBloc, AuthenticationState>(
      '[unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => _aR.status).thenAnswer(
          (_) => Stream.value(AuthStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );
    blocTest<AuthenticationBloc, AuthenticationState>(
      '[authenticated] when status is authenticated',
      setUp: () {
        when(() => _aR.status).thenAnswer(
          (_) => Stream.value(AuthStatus.authenticated),
        );
        when(() => _uR.user).thenAnswer((_) async => _user);
      },
      build: () => AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(_user),
      ],
    );
  });
  group('AuthenticationLogoutRequested', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logOut on authenticationRepository '
      'when AuthenticationLogoutRequested is added',
      setUp: () {
        when(() => _aR.signOut()).thenAnswer((_) async => Null);
      },
      build: () => AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => _aR.signOut()).called(1);
      },
    );
  });

  group('AuthenticationStatusChanged', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated but get user fails',
      setUp: () {
        when(() => _aR.status).thenAnswer(
          (_) => Stream.value(AuthStatus.authenticated),
        );
        // when(() => _uR.getUser('demo@user')).thenThrow(Exception('error'));
        // when(() => _uR.user).thenThrow(Exception('test error'));
        when(() => _uR.user).thenAnswer((_) async => Future.value(null));
      },
      build: () => AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      ),
      act: (bloc) => bloc.add(
        AuthenticationStatusChanged(AuthStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated get user returns the user object',
      setUp: () {
        when(() => _aR.status).thenAnswer(
              (_) => Stream.value(AuthStatus.authenticated),
        );
        when(() => _uR.user).thenAnswer((_) async => Future.value(_user));
      },
      build: () => AuthenticationBloc(
        aRepo: _aR,
        uRepo: _uR,
      ),
      act: (bloc) => bloc.add(
        AuthenticationStatusChanged(AuthStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(_user),
      ],
    );
  });
}

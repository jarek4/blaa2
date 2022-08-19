import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockUserRepoI extends Mock implements UserRepoI<User> {}

void main() {
  late AuthRepo aR;
  late UserRepoI<User> uR;
  // late StreamController<AuthStatus> authStatusCtr;
  // late StorageSecInterface secureStorage;
  setUpAll(() {
    // aR = MockAuthRepo();
    // authStatusCtr = MockStreamController();
    // secureStorage = MockStorageSecInterface();
    //  when(() => aR.status).thenAnswer((_) => const Stream.empty());
    uR = MockUserRepoI();
    aR = AuthRepo(uR);
  });

  tearDown(() {
    // authStatusCtr.close();
  });

  group('AuthenticationRepository signIn method should', () {
    setUp(() {
      when(() => uR.loginUserWithEmailPassword("email", 'password'))
          .thenAnswer((_) async => null);
    });
    test('emmit AuthStatus.unauthenticated when cannot log in', () async {
      // arrange
      // act
      await aR.signIn(email: "email", password: 'password');

      // assert
      expect(await aR.status.first, AuthStatus.unauthenticated);
      // authStatusCtr.close();
    });
    test('return null user repository returns null (no user)', () async {
      // arrange
      // act
      int? res = await aR.signIn(email: "email", password: 'password');

      // assert
      expect(res, null);
    });
  });

  group('Authentication Repository signOut method should', () {
    setUp(() {});
    test('test 1', () async {
      // arrange
      // act
      // assert
    });
    test('test 2', () async {
      // arrange
      // act
      // assert
    });
  });
}

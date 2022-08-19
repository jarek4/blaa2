import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// UserRepo is a singleton
class MockUserRepo extends Mock implements UserRepo {}

void main() {
  EquatableConfig.stringify = true;
  const mockUser = User(id: 1, email: 'email');
  late UserRepo uRMock;
  late UserRepo uR;
  setUpAll(() {});
  tearDown(() {});
  group('UserRepository getter  should', () {
    setUp(() {
      uRMock = MockUserRepo();
      uR = UserRepo();
    });
    test('return <User?> type', () async {
      when(() => uRMock.user).thenAnswer((_) async => mockUser);
      User? res = await uRMock.user;
      expect(res, isA<User?>());
    });
    test('return null if there is no user', () async {
      // visibleForTesting userForTest()
      await uR.userForTest(null);
      User? res = await uR.user;
      expect(res, null);
    });
    test('return the user if there is the user ', () async {
      // visibleForTesting userForTest()
      await uR.userForTest(mockUser);
      User? res = await uR.user;
      expect(res, mockUser);
    });
  });
}

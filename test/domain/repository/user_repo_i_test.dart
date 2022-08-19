import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepoI<User> extends Mock implements UserRepoI<User> {}

void main() {
  EquatableConfig.stringify = true;
  late MockUserRepoI<User> uRI;
  const mockUser = User();
  tearDown(() {});
  group('UserRepositoryInterface<User> should', () {
    setUp(() {
      uRI = MockUserRepoI();
    });
    test('return User type when getUser("any")', () async {
      // arrange
      when(() => uRI.getUser("any")).thenAnswer((_) async => mockUser);
      // act
      User? _res = await uRI.getUser("any");
      // assert
      expect(_res, mockUser);
      verify(() => uRI.getUser("any")).called(1);
    });
    test('return null type when get user', () async {
      // arrange
      when(() => uRI.user).thenAnswer((_) async => null);
      // act
      User? _res = await uRI.user;
      // assert
      expect(_res, null);
      verify(() => uRI.user).called(1);
    });
  });
}

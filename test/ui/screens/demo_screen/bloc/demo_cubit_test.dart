import 'package:blaa/data/dummy/dummy_words.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';
import 'package:blaa/ui/screens/demo_screen/bloc/demo_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

/*@GenerateMocks([
  DemoWordsRepositoryI
], customMocks: [
  MockSpec<DemoWordsRepositoryI<Word>>()
])*/

// A Mock DemoWordsRepositoryI class
class MockDemoWordsRepositoryI extends Mock
    implements DemoWordsRepositoryI<Word> {}

void main() {
  EquatableConfig.stringify = true;
  late DemoWordsRepositoryI<Word> repository;
  late DemoCubit cubit;
  final List<Word> _listOneWord = demo1WordList;
  setUpAll(() {
  });
  tearDown(() {
    cubit.close();
  });
  group('DemoCubit emits state:', () {
    setUp(() {
      repository = MockDemoWordsRepositoryI();
      // DemoCubit(this.repository) : super(const DemoState.loading());
      cubit = DemoCubit(repository);
    });
    blocTest<DemoCubit, DemoState>(
      'initial',
      // build is like a create - BlocProvider<BlocA>(create: (_) => BlocA())
      build: () => DemoCubit(repository),
      act: (DemoCubit cubit) => cubit.emit(const DemoState.loading()),
      expect: () => [isA<DemoState>()],
    );

    blocTest<DemoCubit, DemoState>(
      'DemoState when fetchWords() ',
      build: () {
        when(() => repository.getDemoWords()).thenReturn(_listOneWord);
        return cubit;
      },
      act: (DemoCubit cubit) => cubit.fetchWords(),
      expect: () => [isA<DemoState>(), isA<DemoState>()],
    );
    blocTest<DemoCubit, DemoState>(
      'loading and success when fetchWords(_listOneWord) ',
      build: () {
        when(() => repository.getDemoWords()).thenReturn(_listOneWord);
        return cubit;
      },
      act: (DemoCubit cubit) => cubit.fetchWords(),
      expect: () =>
          [const DemoState.loading(), DemoState.success(_listOneWord)],
    );
  });
  group('DemoCubit emits DemoState.failure on Exception', () {
    setUp(() {
      repository = MockDemoWordsRepositoryI();
      cubit = DemoCubit(repository);
    });
    blocTest<DemoCubit, DemoState>(
      'when DemoState.failure(test fail) is emitted',
      build: () => DemoCubit(repository),
      act: (DemoCubit cubit) =>
          cubit.emit(const DemoState.failure('test fail')),
      expect: () => [const DemoState.failure('test fail')],
    );
    blocTest<DemoCubit, DemoState>(
      'when repository.getDemoWords() throws an Exception',
      // build is like a create - BlocProvider<BlocA>(create: (_) => BlocA())
      build: () {
        when(() => repository.getDemoWords())
            .thenThrow(Exception('getDemoWords error'));
        return cubit;
      },
      act: (DemoCubit cubit) => cubit.fetchWords(),
      expect: () => [
        isA<DemoState>(),
        const DemoState.failure('Something went wrong. Please try again')
      ],
    );
  });
}

import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/data/repositories/demo_words_repository.dart';
import 'package:blaa/data/repositories/user_repo.dart';
import 'package:blaa/data/repositories/words_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MultiRepositoryProvider buildMultiRepositoryProvider(
    BuildContext context, MultiBlocProvider mBlocProvider) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<UserRepoI<User>>(
        create: (context) => UserRepo(),
      ),
      RepositoryProvider<AuthRepoI<AuthStatus>>(
        create: (context) => AuthRepo(context.read<UserRepoI<User>>()),
      ),
      RepositoryProvider<DemoWordsRepositoryI<Word>>(
        create: (context) => DemoWordsRepo(),
      ),
      RepositoryProvider<WordsRepoI<Word>>(
        create: (context) => WordsRepo(),
      ),
    ],
    child: mBlocProvider,
  );
}

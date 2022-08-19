import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/blocs/settings_cubit/settings_cubit.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:blaa/ui/screens/demo_screen/bloc/demo_cubit.dart';
import 'package:blaa/ui/screens/edit_word_screen/cubit/edit_word_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MultiBlocProvider buildMultiBlocProvider(BuildContext context, Widget child) {
  return MultiBlocProvider(providers: <BlocProvider>[
    BlocProvider<SettingsCubit>(
        create: (BuildContext context) => SettingsCubit()),
    BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => AuthenticationBloc(
          aRepo: context.read<AuthRepoI<AuthStatus>>(),
          uRepo: context.read<UserRepoI<User>>())
        ..add(AuthenticationAtAppStart()),
      lazy: false,
    ),
    BlocProvider<WordsCubit>(
      create: (BuildContext context) => WordsCubit(
        context.read<WordsRepoI<Word>>(),
        context.read<AuthenticationBloc>(),
      )..fetchWords(),
      lazy: false,
    ),
    BlocProvider<DemoCubit>(
        create: (BuildContext context) =>
            DemoCubit(context.read<DemoWordsRepositoryI<Word>>())
              ..fetchWords()),
    BlocProvider<EditWordCubit>(
        create: (BuildContext context) =>
            EditWordCubit(context.read<WordsRepoI<Word>>())),
  ], child: child);
}

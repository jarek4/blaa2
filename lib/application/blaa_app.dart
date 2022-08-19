import 'package:blaa/blocs/bloc_providers/bloc_providers.dart';
import 'package:blaa/blocs/bloc_repositories/bloc_repositories.dart';
import 'package:blaa/blocs/settings_cubit/settings_cubit.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:blaa/utils/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ApplicationBlaaa extends StatelessWidget {
  ApplicationBlaaa({Key? key}) : super(key: key);
  final _blaaRouter = BlaaRouter();
  static const MaterialColor _primaryColor = Colors.amber;

  @override
  Widget build(BuildContext context) {
    // buildMultiRepositoryProvider returns
    //  MultiRepositoryProvider(providers: [ RepositoryProvider<T>()])
    //
    // buildMultiBlocProvider returns
    //  MultiBlocProvider(providers: <BlocProvider>[ BlocProvider<BlocA>()])
    return buildMultiRepositoryProvider(
        context,
        buildMultiBlocProvider(context,
            BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routeInformationParser: _blaaRouter.defaultRouteParser(),
              routerDelegate: _blaaRouter.delegate(),
              theme: ThemeData(
                  primarySwatch: _primaryColor,
                  primaryColor: _primaryColor,
                  scaffoldBackgroundColor: _primaryColor,
                  textTheme: Theme.of(context).textTheme.copyWith(
                        caption: const TextStyle(color: Colors.blue),
                        subtitle1: const TextStyle(
                            fontFamily: 'Source Sans Pro', fontSize: 10.0),
                      )),
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale(context.read<SettingsCubit>().state.localeCode),
            );
          },
        )));
  }
}
/*
/* MultiRepositoryProvider buildMultiRepositoryProvider(BuildContext context) {
    return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepoI<AuthStatus>>(
        create: (context) => AuthRepo(),
      ),
      RepositoryProvider<UserRepoI<User>>(
        create: (context) => UserRepo(),
      ),
      RepositoryProvider<DemoWordsRepositoryI<Word>>(
        create: (context) => DemoWordsRepo(),
      ),
      RepositoryProvider<WordsRepoI<Word>>(
        create: (context) => WordsRepo(),
      ),
    ],
    child: buildMultiBlocProvider(
        context,
        MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: _blaaRouter.defaultRouteParser(),
          routerDelegate: _blaaRouter.delegate(),
          theme: ThemeData(
              primarySwatch: _primaryColor,
              primaryColor: _primaryColor,
              scaffoldBackgroundColor: _primaryColor,
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: const TextStyle(color: Colors.blue),
                    subtitle1: const TextStyle(
                        fontFamily: 'Garamond', fontSize: 10.0),
                  )),
        )),
  );
  }*/


MultiBlocProvider buildMultiBlocProvider(BuildContext context) {
    return MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => AuthenticationBloc(
                aRepo: context.read<AuthRepoI<AuthStatus>>(),
                uRepo: context.read<UserRepoI<User>>()),
            lazy: false,
          ),
          BlocProvider<WordsCubit>(
              create: (BuildContext context) =>
                  WordsCubit(context.read<WordsRepoI<Word>>())..fetchWords()),
          BlocProvider<DemoCubit>(
              create: (BuildContext context) =>
                  DemoCubit(context.read<DemoWordsRepositoryI<Word>>())
                    ..fetchWords())
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: _blaaRouter.defaultRouteParser(),
          routerDelegate: _blaaRouter.delegate(),
          theme: ThemeData(
              primarySwatch: _primaryColor,
              primaryColor: _primaryColor,
              scaffoldBackgroundColor: _primaryColor,
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: const TextStyle(color: Colors.blue),
                    subtitle1: const TextStyle(
                        fontFamily: 'Garamond', fontSize: 10.0),
                  )),
        ));
  }



  */

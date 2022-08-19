import 'package:auto_route/auto_route.dart';
import 'package:blaa/ui/router/path_const.dart';
import 'package:blaa/ui/screens/demo_screen/demo_screen.dart';
import 'package:blaa/ui/screens/edit_word_screen/edit_word_screen.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/exercise_correct_answer_screen.dart';
import 'package:blaa/ui/screens/exercises_screen/exercises_screen.dart';
import 'package:blaa/ui/screens/home_screen/home_screen.dart';
import 'package:blaa/ui/screens/login_screen/login_screen.dart';
import 'package:blaa/ui/screens/registration_screen/registration_screen.dart';
import 'package:blaa/ui/screens/root_view/root_view.dart';
import 'package:blaa/ui/screens/settings_screen/settings_screen.dart';
import 'package:blaa/ui/screens/study_screen/study_screen.dart';
import 'package:blaa/ui/screens/words_list_screen/words_list_screen.dart';
import 'package:blaa/ui/screens/demo_screen/single_screen/single_screen.dart';

@MaterialAutoRouter(replaceInRouteName: 'Screen,Route', routes: [
  AutoRoute(path: PathConst.root, page: RootView, children: [
    AutoRoute(
        name: 'HomeRouter',
        path: PathConst.home,
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: HomeScreen),
        ]),
    AutoRoute(
        path: PathConst.study,
        page: EmptyRouterPage,
        name: 'StudyRouter',
        children: [
          AutoRoute(page: StudyScreen, initial: true),
          AutoRoute(
              path: PathConst.words,
              page: EmptyRouterPage,
              name: 'WordsListRouter',
              children: [
                AutoRoute(page: WordsListScreen, initial: true),
                AutoRoute(page: EditWordScreen, path: ':id'),
              ]),
          AutoRoute(
              path: PathConst.exercises,
              page: EmptyRouterPage,
              name: 'ExercisesRouter',
              children: [
                AutoRoute(page: Exercises, initial: true),
                AutoRoute(
                    path: PathConst.exercise,
                    page: EmptyRouterPage,
                    name: 'Exercise',
                    children: [
                      AutoRoute(page: ExerciseCorrectAnswer, initial: true),
                    ]),
              ]),
          AutoRoute(
              path: PathConst.demo,
              page: EmptyRouterPage,
              name: 'DemoRouter',
              children: [
                AutoRoute(page: DemoScreen, initial: true),
                AutoRoute(page: SingleScreen, path: ':itemId'),
              ]),
        ]),
    AutoRoute(
        path: PathConst.settings,
        page: EmptyRouterPage,
        name: 'SettingsRouter',
        children: [
          AutoRoute(page: SettingsScreen, initial: true),
          AutoRoute(path: PathConst.login, page: LoginScreen),
          AutoRoute(path: PathConst.signUp, page: RegistrationScreen),
        ]),
  ]),
])
class $BlaaRouter {}

/*
flutter pub run build_runner build --delete-conflicting-outputs
class RoutesConst {
  static const String add = 'add';
  static const String auth = 'auth';
  static const String demo = 'demo';
  static const String exercises = 'exercises';
  static const String exercise = 'exercise';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String root = '/';
  static const String settings = 'settings';
  static const String signIn = 'sign_in';
  static const String signUp = 'sign_up';
  static const String study = 'study';
  static const String words = 'words';
}
 */

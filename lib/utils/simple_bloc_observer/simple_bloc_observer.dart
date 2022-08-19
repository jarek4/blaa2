// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

 /* @override
  void onChange(BlocBase bloc, Change change) {
    // debugPrint(change.toString());
    // print(change);
    super.onChange(bloc, change);
  }*/

  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  /*@override
  void onTransition(Bloc bloc, Transition transition) {
    // print(transition);
    super.onTransition(bloc, transition);
  }*/
}

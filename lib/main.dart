import 'package:blaa/application/blaa_app.dart';
import 'package:blaa/data/providers/shared_pref/shared_pref.dart';
import 'package:blaa/utils/simple_bloc_observer/simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterServicesBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SharedPref.init();
  BlocOverrides.runZoned(
    () => runApp(ApplicationBlaaa()),
    blocObserver: SimpleBlocObserver(),
  );
  // runApp(ApplicationBlaaa());
}

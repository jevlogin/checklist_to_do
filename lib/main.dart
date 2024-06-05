import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/user_repository.dart';

import 'app.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();
  await initFirebase();

  GetIt.I<Talker>().info('App started with Talker');

  Bloc.observer = TalkerBlocObserver(
      talker: GetIt.I<Talker>(),
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: false,
      ));

  FlutterError.onError = (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() => runApp(const MyApp()),
          (error, stack) => GetIt.I<Talker>().handle(error, stack));
}

void setupDependencies() {
  final talker = TalkerFlutter.init();
  getIt
    ..registerSingleton(talker)
    ..registerSingletonAsync<SharedPreferences>(() async => SharedPreferences.getInstance())
    ..registerLazySingleton<UserRepository>(() => FirebaseUserRepo());
}

Future<void> initFirebase() async {
  try {
    final firebase = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    GetIt.I<Talker>().info(firebase.options.projectId);
  } catch (e, st) {
    GetIt.I<Talker>().handle('Error initialization Firebase\n$e', st);
  }
}
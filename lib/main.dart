import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/user_repository.dart';

import 'app.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
final talker = TalkerFlutter.init();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton(talker);
  GetIt.I<Talker>().info('App started with Talker');

  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  talker.info(firebase.options.projectId);

  getIt.registerLazySingleton<UserRepository>(
          () => FirebaseUserRepo());


  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: false,
      ));

  FlutterError.onError = (details) => talker.handle(details.exception, details.stack);

  runZonedGuarded(() => runApp(const MyApp()),
          (error, stack) => talker.handle(error, stack));
}

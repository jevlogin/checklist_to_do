import 'package:checklist_to_do/blocs/authentication/authentication_bloc.dart';
import 'package:checklist_to_do/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepository: GetIt.I<UserRepository>()),
      child: MaterialApp.router(
          title: 'Firebase Auth',
          theme: _buildThemeData(),
          routerConfig: _appRouter.config(
            navigatorObservers: () => [
              TalkerRouteObserver(GetIt.I<Talker>()),
            ],
          )),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
        colorScheme: const ColorScheme.light(
            surface: Colors.white,
            onSurface: Colors.black,
            primary: Color.fromRGBO(206, 147, 216, 1.0),
            onPrimary: Colors.black,
            secondary: Color.fromRGBO(244, 143, 177, 1.0),
            onSecondary: Colors.white,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242)));
  }
}

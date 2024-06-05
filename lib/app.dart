import 'package:checklist_to_do/blocs/authentication/authentication_bloc.dart';
import 'package:checklist_to_do/blocs/theme/theme_cubit.dart';
import 'package:checklist_to_do/blocs/theme/theme_state.dart';
import 'package:checklist_to_do/repositories/settings/settings.dart';
import 'package:checklist_to_do/router/router.dart';
import 'package:checklist_to_do/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  final settingsRepository = SettingsRepository(preferences: GetIt.I<SharedPreferences>());

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: GetIt.I<UserRepository>()),
        ),
        RepositoryProvider(
          create: (context) => ThemeCubit(settingsRepositoryInterface: settingsRepository),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
              title: 'Firebase Auth',
              theme: _getTheme(state),
              routerConfig: _appRouter.config(
                navigatorObservers: () =>
                [
                  TalkerRouteObserver(GetIt.I<Talker>()),
                ],
              ));
        },
      ),
    );
  }

  ThemeData _getTheme(ThemeState state) => state.isDark ? darkTheme : lightTheme;
}

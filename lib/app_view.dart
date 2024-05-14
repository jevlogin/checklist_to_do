import 'package:auto_route/auto_route.dart';
import 'package:checklist_to_do/blocs/authentication/authentication_bloc.dart';
import 'package:checklist_to_do/blocs/authentication/authentication_state.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_bloc.dart';
import 'package:checklist_to_do/screens/auth/welcome_screen.dart';
import 'package:checklist_to_do/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:user_repository/user_repository.dart';


@RoutePage()
class MyAppViewScreen extends StatefulWidget {
  const MyAppViewScreen({super.key});

  @override
  State<MyAppViewScreen> createState() => _MyAppViewScreenState();
}

class _MyAppViewScreenState extends State<MyAppViewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == Authentication.authenticated) {
          return _buildAuthenticatedWidget(context);
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }

  Widget _buildAuthenticatedWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        repository: GetIt.I<UserRepository>(),
      ),
      child: const HomeScreen(),
    );
  }
}

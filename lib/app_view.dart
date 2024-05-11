import 'package:checklist_to_do/blocs/authentication/authentication_bloc.dart';
import 'package:checklist_to_do/blocs/authentication/authentication_state.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_bloc.dart';
import 'package:checklist_to_do/screens/auth/welcome_screen.dart';
import 'package:checklist_to_do/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Auth',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                surface: Colors.white,
                onSurface: Colors.black,
                primary: Color.fromRGBO(206, 147, 216, 1.0),
                onPrimary: Colors.black,
                secondary: Color.fromRGBO(244, 143, 177, 1.0),
                onSecondary: Colors.white,
                tertiary: Color.fromRGBO(255, 204, 128, 1),
                error: Colors.red,
                outline: Color(0xFF424242)
            )),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == Authentication.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                  repository: context.read<AuthenticationBloc>().userRepository
                ),
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ));
  }
}

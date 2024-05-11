import 'package:checklist_to_do/app_view.dart';
import 'package:checklist_to_do/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseUserRepo = GetIt.I<UserRepository>();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(userRepository: firebaseUserRepo),
      child: const MyAppView(),
    );
  }
}

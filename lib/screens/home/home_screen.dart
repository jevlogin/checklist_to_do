import 'package:checklist_to_do/blocs/sign_in/sign_in_bloc.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, you are In!'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequiredEvent());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Здесь будет распологаться основное содержимое приложения для каждого конкретного пользователя',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(175, 102, 248, 1.0)),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_bloc.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_event.dart';
import 'package:checklist_to_do/blocs/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:user_repository/user_repository.dart';

import '../screens.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userToDo;
  var _selectedPageIndex = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = context.watch<ThemeCubit>().state.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist ToDo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequiredEvent());
            },
            icon: const Icon(Icons.logout),
          )
        ],
        leading: IconButton(
          onPressed: () {
            context.read<ThemeCubit>().setThemeBrightness(
                isDarkTheme ? Brightness.light : Brightness.dark);
          },
          icon: const Icon(CupertinoIcons.triangle_lefthalf_fill),
        ),
      ),
      body: PageView(
          onPageChanged: (value) {
            setState(() => _selectedPageIndex = value);
          },
          controller: _pageController,
          children: const [
            ListItemsScreen(),
            ProfileScreen(),
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add item'),
                  content: TextField(
                    onChanged: (String text) {
                      userToDo = text;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        GetIt.I<UserRepository>().addItem(userToDo);
                        Navigator.pop(context);
                      },
                      child: const Text('Add item'),
                    )
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).hintColor,
        currentIndex: _selectedPageIndex,
        onTap: _openPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: 'Note'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _openPage(int index) {
    setState(() => _selectedPageIndex = index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInExpo);
  }
}

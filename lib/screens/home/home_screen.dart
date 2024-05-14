import 'package:auto_route/annotations.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_bloc.dart';
import 'package:checklist_to_do/blocs/sign_in/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:user_repository/user_repository.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userToDo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist ToDo'),
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
      body: StreamBuilder(
        stream: GetIt.I<UserRepository>().itemsCurrentReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Text('No data');
          } else {
            // return const Text('Here\'s data');
            return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index].get('title')),
                        trailing: IconButton(
                          onPressed: () {
                            GetIt.I<UserRepository>()
                                .itemsReference
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          icon: Icon(
                            Icons.delete_sweep,
                            size: 24,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      GetIt.I<UserRepository>()
                          .itemsReference
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                    },
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
    );
  }
}

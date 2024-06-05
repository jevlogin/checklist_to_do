import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:user_repository/user_repository.dart';

@RoutePage()
class ListItemsScreen extends StatelessWidget {
  const ListItemsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetIt.I<UserRepository>().itemsCurrentReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Text('No data');
        } else {
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
                        icon: const Icon(
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:user_repository/src/models/user/my_user.dart';

class ListFriendsScreen extends StatelessWidget {
  final List<MyUser> friends;
  const ListFriendsScreen({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          title: Text(friend.firstName.isNotEmpty ? friend.firstName : friend.email),
        );
      },
    );
  }
}
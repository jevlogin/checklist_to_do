import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:checklist_to_do/screens/friends/list_friends_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/user_repository.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _friendEmailController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final UserRepository userRepo = GetIt.I<UserRepository>();
  final _focusNode = FocusNode();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  void initState() {
    _setName();
    super.initState();
  }

  void _setName() {
    userRepo.getUserData().then((user) {
      if (user != null) {
        setState(() {
          _nameController.text = user.firstName.isNotEmpty == true ? user.firstName : '';
        });
      }
    }).catchError((error) {
      GetIt.I<Talker>().error('Error receiving user data: $error');
    });
  }

  @override
  build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _showAddFriendDialog,
                child: const Text('Add Friend'),
              ),
              const SizedBox(height: 20.0,),
              Expanded(
                child: StreamBuilder<List<MyUser>>(stream: userRepo.getUserFriends(),
                    builder: (BuildContext context, AsyncSnapshot<List<MyUser>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator.adaptive();
                      } else if (snapshot.hasError) {
                        GetIt.I<Talker>().error('Snapshot.error: ${snapshot.error}');
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          'You have no friends added',
                          style: TextStyle(fontSize: 18),
                        );
                      } else {
                        return ListFriendsScreen(
                          friends: snapshot.data!,
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFriendDialog() {
    _friendEmailController.clear();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Friend'),
            content: TextField(
              controller: _friendEmailController,
              decoration: const InputDecoration(labelText: 'Friend\'s Email:'),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Add Friend'),
                onPressed: () => _addFriend(context),
              ),
            ],
          );
        });
  }

  Future<void> _addFriend(BuildContext context) async {
    try {
      final status = await userRepo.addFriend(_friendEmailController.text);
      if (status) {
        _showSuccessDialog(context);
      } else {
        _showErrorDialog(context, 'The user has not been added because it is you 😊\nOr does this friend already exist');
      }
      _friendEmailController.clear();
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Friend added successfully'),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Failed to add friend: \n$error'),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

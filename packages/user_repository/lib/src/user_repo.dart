import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;
  late CollectionReference usersReference;
  late CollectionReference itemsReference;
  Query<Object?> get itemsCurrentReference;
  Future<MyUser> signUp(MyUser myUser, String password);
  Future<void> setUserData(MyUser user);
  Future<MyUser?> getUserData();
  Future<void> signIn(String email, String password);
  Future<void> logOut();
  Future<void> addItem(String userToDo);
  Future<bool>  addFriend(String text);
  Stream<List<MyUser>> getUserFriends();
  Future<int> getFriendsCount();
}
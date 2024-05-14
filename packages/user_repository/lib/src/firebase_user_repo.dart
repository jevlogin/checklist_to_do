import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/src/models/my_item.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';



class FirebaseUserRepo implements UserRepository {
  FirebaseUserRepo();

  static const String USERS = 'users';
  static const String ITEMS = 'items';

  late final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  CollectionReference usersReference = FirebaseFirestore.instance.collection(USERS);
  @override
  CollectionReference itemsReference = FirebaseFirestore.instance.collection(ITEMS);

  @override
  Query<Object?> get itemsCurrentReference {
    return itemsReference
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> addItem(String userToDo) async {
    var myItem = MyItem.empty;
    var userId = _firebaseAuth.currentUser?.uid ?? '';
    myItem = myItem.copyWith(title: userToDo, userId: userId, timestamp: DateTime.now());
    var data = myItem.toJson();
    itemsReference.add(data);
  }


  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);

      return myUser;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      usersReference.doc(myUser.userId).set(myUser.toEntity().toDocument());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}

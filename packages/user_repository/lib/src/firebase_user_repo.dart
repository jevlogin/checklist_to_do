import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:user_repository/src/models/item/my_item.dart';
import 'package:user_repository/src/models/user/my_user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  FirebaseUserRepo();

  static const String USERS = 'users';
  static const String ITEMS = 'items';

  late final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference friendsReference =
      FirebaseFirestore.instance.collection('friends');

  @override
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection(USERS);
  @override
  CollectionReference itemsReference =
      FirebaseFirestore.instance.collection(ITEMS);

  @override
  Query<Object?> get itemsCurrentReference {
    return itemsReference.where('userId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid);
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
    myItem = myItem.copyWith(
        title: userToDo, userId: userId, timestamp: DateTime.now());
    var data = myItem.toJson();
    itemsReference.add(data);
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
      usersReference.doc(myUser.userId).set(myUser.toJson());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<MyUser?> getUserData() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await usersReference.doc(currentUser.uid).get();
      if (userDoc.exists) {
        MyUser user = MyUser.fromJson(userDoc.data() as Map<String, dynamic>);
        return user;
      }
    }
    return null;
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> addFriend(String friendEmail) async {
    if (friendEmail == _firebaseAuth.currentUser!.email!) {
      GetIt.I<Talker>().warning('The user has not been added because it is you');
      return false;
    }
    var friendUser = await usersReference.where('email', isEqualTo: friendEmail).get();

    if (friendUser.docs.isNotEmpty) {
      var friendData =
          MyUser.fromJson(friendUser.docs.first.data() as Map<String, dynamic>);

      var friendSnapshot = await friendsReference
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('friends')
        .doc(friendData.userId)
        .get();

      if (friendSnapshot.exists) {
        GetIt.I<Talker>().warning('This friend ${friendSnapshot.data()!['email']} already exist');
        return false;
      } else {
        await friendsReference
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('friends')
            .doc(friendData.userId)
            .set({'userId': friendData.userId});
        return true;
      }
    } else {
      throw Exception('User with this email does not exist');
    }
  }

  @override
  Stream<List<MyUser>> getUserFriends() {
    if (_firebaseAuth.currentUser == null) {
      return Stream.value([]);
    }

    return friendsReference
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      var friends = <MyUser>[];
      for (var doc in snapshot.docs) {
        var userData = await usersReference.doc(doc.id).get();
        if (userData.exists) {
          friends.add(MyUser.fromJson(userData.data() as Map<String, dynamic>));
        }
      }

      return friends;
    });
  }

  @override
  Future<int> getFriendsCount() async {
    if (_firebaseAuth.currentUser == null) return 0;
    var friendsSnapshot = await friendsReference
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('friends')
        .get();
    return friendsSnapshot.docs.length;
  }
}

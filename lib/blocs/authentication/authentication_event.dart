import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthentificationEvent extends Equatable {}

class AuthentificationUserChanged extends AuthentificationEvent {
  AuthentificationUserChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user];
}

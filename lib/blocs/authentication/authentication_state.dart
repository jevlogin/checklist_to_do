import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      {this.status = Authentication.unknown, this.user});

  final Authentication status;
  final User? user;

  const AuthenticationState.unknown() : this._();
  const AuthenticationState.authenticated(User user)
      : this._(status: Authentication.authenticated, user: user);
  const AuthenticationState.unauthenticated()
      : this._(status: Authentication.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}

enum Authentication { authenticated, unauthenticated, unknown }

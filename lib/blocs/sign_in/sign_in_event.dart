import 'package:equatable/equatable.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequiredEvent extends SignInEvent {
  final String email;
  final String password;

  const SignInRequiredEvent(this.email, this.password);
}

class SignOutRequiredEvent extends SignInEvent {
  const SignOutRequiredEvent();
}
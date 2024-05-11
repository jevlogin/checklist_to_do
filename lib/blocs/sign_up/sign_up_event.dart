import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

// abstract class SignUpEvent extends Equatable {}
sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequiredEvent extends SignUpEvent {
  final MyUser user;
  final String password;

  const SignUpRequiredEvent(this.user, this.password);

  @override
  List<Object?> get props => [user, password];
}
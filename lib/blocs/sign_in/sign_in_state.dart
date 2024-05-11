import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable{
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInInitState extends SignInState {}

class SignInSuccessState extends SignInState {}
class SignInFailureState extends SignInState {
  final String? message;

  const SignInFailureState({this.message});
}

class SignInProcessState extends SignInState {}
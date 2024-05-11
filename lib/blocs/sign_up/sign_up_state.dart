import 'package:equatable/equatable.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

final class SignUpInitialState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}
class SignUpProcessState extends SignUpState {}
class SignUpFailureState extends SignUpState {}
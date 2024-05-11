import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  // SignInBloc(this._userRepository) :
  SignInBloc({required UserRepository repository})
      : _userRepository = repository,
        super(SignInInitState()) {
    on<SignInRequiredEvent>(_init);
    on<SignOutRequiredEvent>(_signOut);
  }

  void _init(SignInRequiredEvent event, Emitter<SignInState> emit) async {
    emit(SignInProcessState());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(SignInSuccessState());
    } on FirebaseAuthException catch (e, st) {
      emit(SignInFailureState(message: e.code));
    } catch (e, st) {
      emit(const SignInFailureState());
    }
  }

  Future<void> _signOut(SignOutRequiredEvent event, Emitter<SignInState> emit) async {
     await _userRepository.logOut();
  }
}

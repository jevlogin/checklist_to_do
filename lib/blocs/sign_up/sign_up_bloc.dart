import 'package:bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitialState()) {
    on<SignUpRequiredEvent>((event, emit) async {
      emit(SignUpProcessState());
      try {
        MyUser user = await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(user);
        emit(SignUpSuccessState());
      } catch (e, st) {
        emit(SignUpFailureState());
      }
    });
  }
}

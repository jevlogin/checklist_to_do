import 'package:bloc/bloc.dart';

import 'my_user_event.dart';
import 'my_user_state.dart';

class My_userBloc extends Bloc<My_userEvent, My_userState> {
  My_userBloc() : super(My_userState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<My_userState> emit) async {
    emit(state.clone());
  }
}

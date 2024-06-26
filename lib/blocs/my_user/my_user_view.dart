import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_user_bloc.dart';
import 'my_user_event.dart';


class My_userPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => My_userBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<My_userBloc>(context);

    return Container();
  }
}


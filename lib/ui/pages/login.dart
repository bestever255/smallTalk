import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/login/bloc/login_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/login_form.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome',
          style: TextStyle(fontSize: 36),
        ),
        elevation: 0,
        backgroundColor: kBackGroundColor,
      ),
      // Provides the bloc for the descendants
      body: BlocProvider<LoginBloc>(
        create: (ctx) => LoginBloc(),
        child: LoginForm(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/signup/bloc/signup_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/signup_form.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          style: TextStyle(
            fontSize: 36,
          ),
        ),
        centerTitle: true,
        backgroundColor: kBackGroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignupBloc>(
        create: (context) => SignupBloc(),
        child: SignupForm(),
      ),
    );
  }
}

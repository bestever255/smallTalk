import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/ui/pages/login.dart';
import 'package:tinder_clone/repository/profile.dart';
import 'package:tinder_clone/ui/pages/splash_page.dart';
import 'package:tinder_clone/ui/widgets/tabs.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashPage();
            } else if (state is Authenticated) {
              return Tabs(state.userId);
            } else if (state is AuthenticatedButNotSet) {
              return Profile();
            } else if (state is Unauthenticated) {
              return Login();
            } else {
              return Login();
            }
          },
        ));
  }
}

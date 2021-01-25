import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/profile/bloc/profile_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/profile_form.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        centerTitle: true,
        backgroundColor: kBackGroundColor,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(),
        child: ProfileForm(),
      ),
    );
  }
}

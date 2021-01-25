import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/ui/pages/home.dart';

import 'Dependency Injection/locator.dart';

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc()..add(AppStarted()),
    child: Home(),
  ));
}

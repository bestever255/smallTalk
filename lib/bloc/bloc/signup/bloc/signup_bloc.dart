import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/validators.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final _userRepository = GetIt.I.get<UserRepository>();
  SignupBloc() : super(SignupState.empty());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignupWithCredentialsPressedToState(
          event.email, event.password);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<SignupState> _mapSignupWithCredentialsPressedToState(
      String email, String password) async* {
    yield SignupState.loading();
    try {
      await _userRepository.signUpWithEmailAndPassword(email, password);
      yield SignupState.success();
    } catch (e) {
      yield SignupState.failure();
      throw e;
    }
  }
}

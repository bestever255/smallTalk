import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/validators.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository _userRepository;
  SignupBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(SignupState.empty());

  // @override
  // Stream<SignupState> transformEvents(
  //   Stream<SignupEvent> events,
  //   Stream<SignupState> Function(SignupEvent event) next,
  // ) {
  //   // We do debounce if we need to delay the validation so we give the user time to write and not show error always
  //   // So we need to debounce email and password
  //   final nonDebounceStream = events.where((event) {
  //     return (event is! EmailChanged || event is! PasswordChanged);
  //   });
  //   final debounceStream = events.where((event) {
  //     return (event is EmailChanged || event is PasswordChanged);
  //   }).debounceTime(Duration(milliseconds: 300));

  //   return super
  //       .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

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

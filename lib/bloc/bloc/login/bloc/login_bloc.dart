import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.empty());

  // @override
  // Stream<LoginState> transformEvents(
  //   Stream<LoginEvent> events,
  //   Stream<LoginState> Function(LoginEvent event) next,
  // ) {
  //   // We do debounce if we need to delay the validation so we give the user time to write and not show error always
  //   // So we need to debounce email and password
  //   final nonDebounceStream = events.where((event) {
  //     return (event is! EmailChanged || event is! PasswordChanged);
  //   });
  //   final debounceStream = events.where((event) {
  //     return (event is EmailChanged || event is PasswordChanged);
  //   }).debounceTime(Duration(milliseconds: 300));

  //   return events
  //       .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          event.email, event.password);
    }
  }

  // async* is used to use yield keyword which returns a stream
  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    // returns true or false on email
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      String email, String password) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithEmailAndPassword(email, password);
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
      throw e;
    }
  }
}

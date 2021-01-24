import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

// Takes Events and convert them to States
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is UserOpenedApp) {
      yield* _mapUserOpenedAppToState(userId: event.userId);
    } else if (event is UserClosedApp) {
      yield* _mapUserClosedAppToState(userId: event.userId);
    }
  }

  // We take event we return stream of state
  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final uid = await _userRepository.getUser();
        final isFirstTime = await _userRepository.isFirstTime(uid);
        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final userId = await _userRepository.getUser();
    final isFirstTime = await _userRepository.isFirstTime(userId);
    await _userRepository.userOnline(userId);
    if (!isFirstTime) {
      yield AuthenticatedButNotSet(await _userRepository.getUser());
    } else {
      yield Authenticated(await _userRepository.getUser());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    final userId = await _userRepository.getUser();
    await _userRepository.userOffline(userId);
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapUserOpenedAppToState({String userId}) async* {
    yield PhotoLoading();
    User _user = User();
    String photoUrl;
    await _userRepository.userOnline(userId);
    _user = await _userRepository.getUserProfile(currentUserId: userId);
    photoUrl = _user.photo;
    yield PhotoLoaded(photoUrl);
  }

  Stream<AuthenticationState> _mapUserClosedAppToState({String userId}) async* {
    await _userRepository.userOffline(userId);
  }
}
